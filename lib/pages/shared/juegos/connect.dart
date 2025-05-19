import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ConnectTheDotsGame extends StatefulWidget {
  const ConnectTheDotsGame({Key? key}) : super(key: key);

  @override
  _ConnectTheDotsGameState createState() => _ConnectTheDotsGameState();
}


class _ConnectTheDotsGameState extends State<ConnectTheDotsGame> {
  final int rows = 7;
  final int cols = 7;
  late List<List<int?>> gridNumbers = [];
  late int totalCells;
  late int numBalls;
  late List<Point<int>> fullPath = [];

  List<Offset> pathPoints = [];
  List<Point<int>> pathCells = [];
  bool started = false;

  @override
  void initState() {
    super.initState();
    totalCells = rows * cols;
    fullPath = _computeFullPath();
    _generateGrid();
  }

  // Generate a random Hamiltonian path covering all cells via DFS backtracking
  List<Point<int>> _computeFullPath() {
    List<Point<int>> path = [];
    Set<Point<int>> visited = {};
    final rng = Random();

    bool dfs(Point<int> cell) {
      visited.add(cell);
      path.add(cell);
      if (path.length == totalCells) return true;

      // Generate neighbors in 4 directions
      List<Point<int>> neighbors = [];
      var deltas = [Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1)];
      for (var d in deltas) {
        int nr = cell.x + (d.x as int);
        int nc = cell.y + (d.y as int);
        var np = Point(nr, nc);
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && !visited.contains(np)) {
          neighbors.add(np);
        }
      }
      // Shuffle to randomize labyrinthine path
      neighbors.shuffle(rng);
      for (var n in neighbors) {
        if (dfs(n)) return true;
      }
      // Backtrack
      visited.remove(cell);
      path.removeLast();
      return false;
    }

    // Start DFS from a random starting cell
    Point<int> start = Point(rng.nextInt(rows), rng.nextInt(cols));
    dfs(start);
    return path;
  }

  void _generateGrid() {
    final rng = Random();
    // Decide number of balls between 6 and 12
    numBalls = rng.nextInt(7) + 6;
    // Select unique positions along the fullPath to place balls
    Set<int> indices = {0, fullPath.length - 1};
    while (indices.length < numBalls) {
      indices.add(rng.nextInt(fullPath.length));
    }
    List<int> sorted = indices.toList()..sort();

    // Initialize grid and place numbered balls
    gridNumbers = List.generate(rows, (_) => List.generate(cols, (_) => null));
    for (int i = 0; i < sorted.length; i++) {
      var p = fullPath[sorted[i]];
      gridNumbers[p.x][p.y] = i + 1;
    }

    pathPoints.clear();
    pathCells.clear();
    started = false;
  }

  Offset cellCenter(int row, int col, Size size) {
    double cw = size.width / cols;
    double ch = size.height / rows;
    return Offset(col * cw + cw / 2, row * ch + ch / 2);
  }

  Point<int>? hitCell(Offset pos, Size size) {
    double cw = size.width / cols;
    double ch = size.height / rows;
    int col = (pos.dx / cw).floor();
    int row = (pos.dy / ch).floor();
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      return Point(row, col);
    }
    return null;
  }

  bool isAdjacent(Point<int> a, Point<int> b) => (a.x - b.x).abs() + (a.y - b.y).abs() == 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (d) => _handleTouch(d.localPosition),
      onPanUpdate: (d) => _handleTouch(d.localPosition),
      child: CustomPaint(
        painter: ConnectPainter(gridNumbers: gridNumbers, path: pathPoints),
        child: Container(),
      ),
    );
  }

  void _handleTouch(Offset pos) {
    final size = (context.findRenderObject() as RenderBox).size;
    final cell = hitCell(pos, size);
    if (cell == null) return;

    if (!started) {
      if (gridNumbers[cell.x][cell.y] == 1) started = true;
      else return;
    }

    // Undo if going back
    if (pathCells.length >= 2 && cell == pathCells[pathCells.length - 2]) {
      setState(() {
        pathCells.removeLast();
        pathPoints.removeLast();
      });
      return;
    }

    // Prevent revisit or invalid
    if (pathCells.contains(cell)) return;
    if (pathCells.isNotEmpty && !isAdjacent(cell, pathCells.last)) return;

    setState(() {
      pathCells.add(cell);
      pathPoints.add(cellCenter(cell.x, cell.y, size));
    });

    // Win when all cells visited and balls connected
    if (pathCells.length == totalCells &&
        pathCells.where((p) => gridNumbers[p.x][p.y] != null).length == numBalls) {
      _showWin();
    }
  }

  void _showWin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¡Bien hecho!'),
        content: const Text('Has conectado todas las pelotas y cubierto el tablero.'),
        actions: [
          TextButton(
            onPressed: () { Navigator.of(context).pop(); setState(_generateGrid); },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}

class ConnectPainter extends CustomPainter {
  final List<List<int?>> gridNumbers;
  final List<Offset> path;
  ConnectPainter({required this.gridNumbers, required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()..color = Colors.grey.shade300..style = PaintingStyle.stroke;
    final paintBall = Paint()..color = Colors.blue.shade200;
    final tp = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    final paintPath = Paint()..color = Colors.red..strokeWidth = 4..style = PaintingStyle.stroke;

    double cw = size.width / gridNumbers[0].length;
    double ch = size.height / gridNumbers.length;

    for (int r = 0; r < gridNumbers.length; r++) {
      for (int c = 0; c < gridNumbers[r].length; c++) {
        final left = c * cw;
        final top = r * ch;
        canvas.drawRect(Rect.fromLTWH(left, top, cw, ch), paintGrid);
        final num = gridNumbers[r][c];
        if (num != null) {
          final center = Offset(left + cw / 2, top + ch / 2);
          canvas.drawCircle(center, min(cw, ch) * 0.3, paintBall);
          tp.text = TextSpan(text: num.toString(), style: TextStyle(color: Colors.black, fontSize: cw * 0.3));
          tp.layout(minWidth: 0, maxWidth: cw);
          tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
        }
      }
    }

    for (int i = 0; i < path.length - 1; i++) {
      canvas.drawLine(path[i], path[i + 1], paintPath);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectPainter old) => true;
}

class Point<T> {
  final T x;
  final T y;
  const Point(this.x, this.y);
  @override
  bool operator ==(Object o) => o is Point<T> && o.x == x && o.y == y;
  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
