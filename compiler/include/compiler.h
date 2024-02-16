#define SYM_N 20000
#define VAR_N 100

typedef enum { constant, operator, id } nodeType;
typedef enum { DECLARE, DECLARE_LIST, PRINT_LIST, ASSIGN, PRINTS, STATEMENTS,
                ADD, SUB, MUL, DIV, MOD, 
                LESS, GREATER, LESSEQ, GREATEREQ, EQ, NOTEQ,
                NOT, AND, OR,
                IF_ELSE } 
                operations;

typedef struct {
    char opr;
    struct nodeTag* op1;
    struct nodeTag* op2;
} oprNode;

typedef struct nodeTag {
    nodeType type;

    union {
        int cValue;
        oprNode oNode;
        char* iName;
    };
} node;

typedef struct {
    int index;
    char* name;
    int value;
    int declared;
    int allocated;
}symtab_entry;

node* cNode(int value);
node* oNode(char opr, node* a, node* b);
node* iNode(char* s);
int evaluateNode(node * inNode);
int printNode(node * inNode);

extern symtab_entry* symtab;

void create_symtab();
int update_var(int index, int value);
int declare_var(char* name); 
int fetch_var(char* name);
int varIndex(char* name);

void throwError(char *s);
