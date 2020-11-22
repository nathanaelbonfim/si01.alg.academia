// Faça um algoritmo que crie um registro com número, nome, idade, sexo e status (A-
// tivo/I-nativo) dos alunos de uma academia. Faça com que as informações sejam gravadas
// em um arquivo. Após as informações estarem gravadas, permita as seguintes instruções:
// Alteração (menos do código), Exclusão lógica (Ativo/Inativo), Listar os alunos, e
// pesquisar os alunos cadastrados por número ou por nome. Monte um menu com a
// estrutura CASE para cada umas dessas instruções.

Program Trabalho;

Type Registro = Record
            numero, idade : integer;
            nome   : string;
            sexo, status : char;
        end;
        Arquivo : file of Registro;
var Arquivo_Acad : Arquivo;
    Acad : Registro;
    i : integer;
    

begin
    Assign (Arquivo_Acad, 'C:\ACADEMIA.DTA'); 
    {$I-}
    Reset(Arquivo_Acad);                    
    {$I+}
    if (IOResult <> 0) then
        Rewrite(Arquivo_Acad);
    end;

    ///CRIAR OS MENUS///
    // 1. 'Cadastro dos alunos da academia'
    // 2. 'Alterar dados do aluno'
    // 3. 'Excluir Aluno'
    // 4. 'Pesquisar aluno pelo código'
    // 5. 'Pesquisar aluno pelo nome'
    // 6. 'Relatório de alunos cadastrados'
    // 7. 'Finalizar'
    ////////////////////

///////criar função para cadastro///////
///Fazer as validações do cadastro///
// a. Código de aluno negativo
// b. Idade negativa ou maior que 150
// c. Sexo diferente de F/M
// d. Status diferente de A/I ou ativo/inativo
    write ('Entre com um número: ');
    readln (Acad.numero);
    write ('Entre com o nome: ');
    readln (Acad.nome);
    write ('Entre com a idade: ');
    readln (Acad.idade);
    write ('Entre com o sexo (M-asculino/F-eminino): ');
    readln (Acad.numero);
    write ('Entre com o status (A-tivo/I-nativo): ');
    readln (Acad.status);
    Write(Arquivo_Acad, Acad);
    //if (quer realizar novo cadastro?) S then
        //function
    //else
        //volta pro menu 
    //end;
////////////////////////////////////////

//////Criar função para procurar os dados pelo número/////
    Seek (Arquivo_Acad, (numero-1));
    read(Arquivo_Acad, Acad);
    //por a function: Impressao dos dados
/////////////////////////////////////////////

//////Criar função para procurar os dados pelo nome/////
    Seek (Arquivo_Acad,.........);
    read(Arquivo_Acad, Acad);
    //por a function: Impressao dos dados
/////////////////////////////////////////////


/////criar function: Impressao dos dados/// 
    Writeln ('O número do registro é: ', Acad.numero);
    Writeln ('O nome do aluno é: ', Acad.nome);
    Writeln ('A idade do aluno é: ', Acad.idade);
    Writeln ('O sexo do aluno é: ', Acad.sexo);
    Writeln ('O status do aluno é: ', Acad.status);
    writeln;
/////////////////////////////////////////////


//////Criar função para alterar os dados/////
/////////////////////////////////////////////

//////Criar função para excluir os dados/////
/////////////////////////////////////////////

//////Criar função para relatório os dados/////
    while (not eof(acad)) do
    begin
        read(Acad, FilePos);
        //Por a function: Impressao de dados
    end;   
/////////////////////////////////////////////



    CLOSE (Arquivo_Acad);
end.
