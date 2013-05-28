#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
int main(int argc, char **argv){
    int peek = strcmp(argv[1], "false");
    char * host = argv[2];
    int git = argc > 3;
    char * sha = git ? argv[3] : 0;

    int idx;
    
    FILE *poemfile = fopen("/home/hmrm/.oh-my-zsh/custom/poems.txt", "r");
    FILE *indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "r");
    if(!indexfile){
        indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w");
        idx = 0;
        fwrite(&idx, sizeof(int), 1, indexfile);
    } else {
        fread(&idx, sizeof(int), 1, indexfile);
    }
    
    char * buffer = NULL;
    size_t n = 0;
    for (int i = 0; i <= idx; i++){
        int ret = getline(&buffer, &n, poemfile);
        if (ret <= 0) {
            fclose(indexfile);
            indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w") ;
            idx = 0;
            fwrite(&idx, sizeof(int), 1, indexfile);
            fclose(indexfile);
            fclose(poemfile);
            exit(0);
        }
    }
    
    printf("%s", buffer);

    if(!peek){
        idx++;
        fclose(indexfile);
        indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w") ;
        fwrite(&idx, sizeof(int), 1, indexfile);
    }
    fclose(indexfile);
    fclose(poemfile);
}
