class Node:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None

class BinarySearchTree:
    def __init__(self):
        self.root = None

    # ---------- Поиск ----------
    def search(self, key):
        """Поиск узла с заданным ключом."""
        return self._search_recursive(self.root, key)

    def _search_recursive(self, node, key):
        if node is None or node.key == key:
            return node
        if key < node.key:
            return self._search_recursive(node.left, key)
        return self._search_recursive(node.right, key)

    # ---------- Вставка ----------
    def insert(self, key):
        """Вставка нового узла с заданным ключом."""
        self.root = self._insert_recursive(self.root, key)

    def _insert_recursive(self, node, key):
        if node is None:
            return Node(key)
        if key < node.key:
            node.left = self._insert_recursive(node.left, key)
        elif key > node.key:
            node.right = self._insert_recursive(node.right, key)
        return node

    # ---------- Удаление ----------
    def delete(self, key):
        """Удаление узла с заданным ключом."""
        self.root = self._delete_recursive(self.root, key)

    def _delete_recursive(self, node, key):
        if node is None:
            return None
        if key < node.key:
            node.left = self._delete_recursive(node.left, key)
        elif key > node.key:
            node.right = self._delete_recursive(node.right, key)
        else:
            # Случай A: Узел без потомков
            if node.left is None and node.right is None:
                return None
            # Случай B: Узел с одним потомком
            if node.left is None:
                return node.right
            if node.right is None:
                return node.left
            # Случай В: Узел с двумя потомками
            min_node = self._find_min(node.right)
            node.key = min_node.key
            node.right = self._delete_recursive(node.right, min_node.key)
        return node

    def _find_min(self, node):
        """Найти узел с минимальным ключом в поддереве."""
        current = node
        while current.left:
            current = current.left
        return current

    # ---------- Печать дерева (в стиле │, ┌──, └──) ----------
    def print_tree(self):
        """Вывод структуры дерева в стиле с │, ┌──, └──."""
        if self.root is None:
            print("Дерево пустое")
            return
        self._print_tree_recursive(self.root, "", True)

    def _print_tree_recursive(self, node, prefix, is_left):
        if node is not None:
            print(prefix, end="")
            print("└── " if is_left else "┌── ", end="")
            print(node.key)
            
            new_prefix = prefix + ("    " if is_left else "│   ")
            
            if node.left or node.right:
                if node.right:
                    self._print_tree_recursive(node.right, new_prefix, False)
                else:
                    print(new_prefix + "┌── None")
                if node.left:
                    self._print_tree_recursive(node.left, new_prefix, True)
                else:
                    print(new_prefix + "└── None")

# ====================== Пример ======================
if __name__ == "__main__":
    bst = BinarySearchTree()
    keys = [50, 30, 70, 20, 40, 60, 80]
    for k in keys:
        bst.insert(k)

    print("\nНачальная структура дерева:")
    bst.print_tree()

    print("\nПосле вставки 100:")
    bst.insert(100)
    bst.print_tree()

    print("\nПример поиска элементов:")
    print("Поиск узла 40:")
    result = bst.search(40)
    print(f"Поиск 40: {'Найден' if result else 'Не найден'}")
    
    print("\nПоиск узла 90:")
    result = bst.search(90)
    print(f"Поиск 90: {'Не найден' if result is None else 'Найден'}")

    print("\nПример удаления узлов:")
    
    # Удаление узла без потомков (20)
    print("\nУдаляем узел 20 (без потомков):")
    bst.delete(20)
    bst.print_tree()
    
    # Удаление узла с одним потомком (30)
    print("\nУдаляем узел 30 (с одним потомком):")
    bst.delete(30)
    bst.print_tree()
    
    # Удаление узла с двумя потомками (50)
    print("\nПеред удалением узла 50 (с двумя потомками):")
    bst.print_tree()
    print("\nУдаляем узел 50 (с двумя потомками):")
    bst.delete(50)
    bst.print_tree()
    
