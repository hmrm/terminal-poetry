#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char ** argv){
    int peek = strcmp(argv[1], "false");
    char * host = argv[2];
    int git = argc > 3;
    char * sha = git ? argv[3] : 0;

    int idx;
    int originalidx;

    FILE *poemfile = fopen("/home/hmrm/.oh-my-zsh/custom/poems.txt", "r");
    FILE *indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "r");
    if(!indexfile){
        indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w");
        idx = 0;
        fwrite(&idx, sizeof(int), 1, indexfile);
    } else {
        fread(&idx, sizeof(int), 1, indexfile);
    }

    originalidx = idx;
    char buffer[512];
    do {
        int itemsread = fread(buffer, sizeof(char), 512, poemfile);
        if(!itemsread){
            fclose(indexfile);
            indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w");
            idx = 0;
            fwrite(&idx, sizeof(int), 1, indexfile);
            fclose(poemfile);
            fclose(indexfile);
            exit(0);
        }
        for(int i = 0; i < 512; i++){
            if(buffer[i] == '\n'){
                idx--;
            }
            if(!idx){
                i++;
                do {
                    if(i == 512)
                        i=0;
                    while(i<512 && buffer[i] != '\n'){
                        printf("%c", buffer[i]);
                        i++;
                    }
                    if(!fread(buffer, sizeof(char), 512, poemfile))
                        exit(1);

                } while (i >= 512);
                break;
            }
        }
    } while (idx > 0);

    if(!peek){
        originalidx++;
        fclose(indexfile);
        indexfile = fopen("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w") ;
        fwrite(&originalidx, sizeof(int), 1, indexfile);
    }
    
    fclose(poemfile);
    fclose(indexfile);        

}
