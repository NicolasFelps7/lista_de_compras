import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A085),
        ),

        scaffoldBackgroundColor: const Color(0xFFF5F7F8),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF16A085),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF16A085),
          foregroundColor: Colors.white,
        ),
      ),

      home: const TelaLista(),
    );
  }
}

// =====================================================
// MODELO ITEM
// =====================================================

class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

// =====================================================
// TELA PRINCIPAL
// =====================================================

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  final List<Item> _itens = [];

  // =====================================================
  // ABRIR TELA DE ADICIONAR ITEM
  // =====================================================

  Future<void> abrirTelaAdicionar() async {
    final novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    if (novoItem != null) {
      setState(() {
        _itens.add(novoItem);
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${novoItem.nome} adicionado à lista',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF16A085),
        ),
      );
    }
  }

  // =====================================================
  // REMOVER ITEM
  // =====================================================

  void removerItem(int indice) {
    final itemRemovido = _itens[indice];

    setState(() {
      _itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${itemRemovido.nome} removido da lista',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE74C3C),
      ),
    );
  }

  // =====================================================
  // MARCAR COMO COMPRADO
  // =====================================================

  void alterarComprado(int indice, bool? valor) {
    setState(() {
      _itens[indice].comprado = valor ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int comprados =
        _itens.where((item) => item.comprado).length;

    final int total = _itens.length;

    return Scaffold(
      // ===================================================
      // APP BAR
      // ===================================================

      appBar: AppBar(
        toolbarHeight: 72,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Compras',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Organize suas compras',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),

              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.18,
                ),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 18,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    '$total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // CONTADOR PEDIDO NA ATIVIDADE
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              12,
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: Colors.white70,
                ),

                const SizedBox(width: 7),

                Text(
                  '$comprados de $total comprados',

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ===================================================
      // BODY
      // ===================================================

      body: _itens.isEmpty
          ? _telaVazia()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                14,
                18,
                14,
                100,
              ),

              itemCount: _itens.length,

              itemBuilder: (context, indice) {
                final item = _itens[indice];

                return Card(
                  elevation: 1.5,

                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),

                  color: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: ListTile(
                    minVerticalPadding: 13,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),

                    // CHECKBOX
                    leading: Checkbox(
                      value: item.comprado,

                      activeColor:
                          const Color(0xFF16A085),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),

                      onChanged: (valor) {
                        alterarComprado(
                          indice,
                          valor,
                        );
                      },
                    ),

                    // NOME
                    title: Text(
                      item.nome,

                      style: TextStyle(
                        fontSize: 16,

                        fontWeight:
                            FontWeight.w600,

                        decoration:
                            item.comprado
                                ? TextDecoration
                                    .lineThrough
                                : TextDecoration.none,

                        color:
                            item.comprado
                                ? Colors.grey
                                : const Color(
                                    0xFF263238,
                                  ),
                      ),
                    ),

                    // QUANTIDADE
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),

                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 15,

                            color:
                                item.comprado
                                    ? Colors.grey
                                    : const Color(
                                        0xFF16A085,
                                      ),
                          ),

                          const SizedBox(width: 5),

                          Text(
                            'Quantidade: ${item.quantidade}',

                            style: TextStyle(
                              fontSize: 13,

                              color:
                                  item.comprado
                                      ? Colors.grey
                                      : const Color(
                                          0xFF607D8B,
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BOTÃO EXCLUIR
                    trailing: IconButton(
                      tooltip: 'Remover item',

                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFE74C3C),
                      ),

                      onPressed: () {
                        removerItem(indice);
                      },
                    ),
                  ),
                );
              },
            ),

      // ===================================================
      // BOTÃO ADICIONAR
      // ===================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: abrirTelaAdicionar,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Novo item',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // TELA VAZIA
  // =====================================================

  Widget _telaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 110,
              height: 110,

              decoration: const BoxDecoration(
                color: Color(0xFFE3F4F1),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.shopping_basket_outlined,
                size: 55,
                color: Color(0xFF16A085),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Sua lista está vazia',

              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Adicione os produtos que você precisa comprar.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF78909C),
              ),
            ),

            const SizedBox(height: 22),

            OutlinedButton.icon(
              onPressed: abrirTelaAdicionar,

              icon: const Icon(
                Icons.add_shopping_cart,
              ),

              label: const Text(
                'Adicionar primeiro item',
              ),

              style: OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(0xFF16A085),

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// TELA ADICIONAR ITEM
// =====================================================

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() =>
      _TelaAdicionarItemState();
}

class _TelaAdicionarItemState
    extends State<TelaAdicionarItem> {
  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController _quantidadeController =
      TextEditingController();

  // =====================================================
  // SALVAR
  // =====================================================

  void salvar() {
    final String nome =
        _nomeController.text.trim();

    final String textoQuantidade =
        _quantidadeController.text.trim();

    // VALIDAÇÃO DO NOME
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite o nome do item.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // CONVERTER QUANTIDADE
    final int? quantidade =
        int.tryParse(textoQuantidade);

    if (quantidade == null || quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite uma quantidade válida.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // CRIA O ITEM
    final Item novoItem = Item(
      nome: nome,
      quantidade: quantidade,
    );

    // VOLTA PARA A TELA PRINCIPAL
    Navigator.pop(
      context,
      novoItem,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo Item',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // CABEÇALHO
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFFE3F4F1),

                borderRadius: BorderRadius.circular(16),
              ),

              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 26,

                    backgroundColor:
                        Color(0xFF16A085),

                    child: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Adicionar produto',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xFF263238),
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Informe o nome e a quantidade.',

                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Color(0xFF607D8B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Nome do item',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // TEXTFIELD NOME
            TextField(
              controller: _nomeController,

              textCapitalization:
                  TextCapitalization.sentences,

              textInputAction: TextInputAction.next,

              decoration: InputDecoration(
                hintText:
                    'Ex: Arroz, feijão, leite...',

                prefixIcon: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Color(0xFF16A085),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),

                  borderSide: BorderSide.none,
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),

                  borderSide: const BorderSide(
                    color: Color(0xFF16A085),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Quantidade',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // TEXTFIELD QUANTIDADE
            TextField(
              controller:
                  _quantidadeController,

              keyboardType:
                  TextInputType.number,

              textInputAction:
                  TextInputAction.done,

              onSubmitted: (_) {
                salvar();
              },

              decoration: InputDecoration(
                hintText: 'Ex: 2',

                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Color(0xFF16A085),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),

                  borderSide: BorderSide.none,
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),

                  borderSide: const BorderSide(
                    color: Color(0xFF16A085),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // BOTÃO SALVAR
            ElevatedButton.icon(
              onPressed: salvar,

              icon: const Icon(
                Icons.check_rounded,
              ),

              label: const Text(
                'SALVAR ITEM',

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF16A085),

                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}