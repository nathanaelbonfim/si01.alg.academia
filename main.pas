Program Padaria;
Uses Crt;

Type Aluno = Record
    cod: Integer;
    nome: String[80];
    idade: Integer;
    sexo: Char;
    status: Char;
End;

Type CaracteresValidos = Record
    lista: Array [0..3] of Char;
End;

Var { Variáveis globais }
    alunoMem: Aluno;
    arqAlunos: File of Aluno;
    escolha: Integer;
    sexoValido: CaracteresValidos;
    statusValido: CaracteresValidos;

Procedure inicializarGlobais();
Begin
    escolha := 0;
    
    sexoValido.lista[0] := 'F';
    sexoValido.lista[1] := 'f';
    sexoValido.lista[2] := 'M';
    sexoValido.lista[3] := 'm';

    statusValido.lista[0] := 'A';
    statusValido.lista[1] := 'a';
    statusValido.lista[2] := 'i';
    statusValido.lista[3] := 'I';
End;

{ Configura o arquivo }
Procedure configArquivo;
Begin
    assign(arqAlunos, 'padaria.dat');
    {$I-}
    reset(arqAlunos);
    {$I+}
    if IOresult <> 0 then
        rewrite(arqAlunos);
End;

{ Desenha uma linha de  caracates }
Procedure menuLinha();
Begin
    writeln('--------------------------------------------------------------------------------');
End;

{ Cabeçalho de cada menu }
Procedure menuCabecalho(titulo: String);
Begin
    menuLinha();
    writeln('| ', titulo);
    menuLinha();
End;

{ Imprime a mensagem 'pressione qualquer tecla para continuar' }
Procedure mensagemContinuar();
Begin
    writeln('<pressione qualquer tecla para continuar>');
    readkey();
End;

{ Retorna um erro quando a opção é inválida }
Procedure opcaoInvalida();
Begin
    clrScr();
    writeln('Opção inválida, tente novamente');
    mensagemContinuar();
End;

{ Tela de finalização do programa }
Procedure encerrarPrograma();
Begin
    ClrScr();
    close(arqAlunos);
    writeln('=> Programa encerrado');
    mensagemContinuar();
    exit; 
End;


{ Tela do menu principal }
Function menuPrincipal: Integer;
Begin
    ClrScr();
    menuCabecalho('ACADEMIA CENTRO SPORT');
    writeln('| 1. Incluir Aluno');
    writeln('| 2. Alterar dados do aluno');
    writeln('| 3. Excluir aluno');
    writeln('| 4. Pesquisar aluno por código');
    writeln('| 5. Pesquisar aluno por nome');
    writeln('| 6. Relatório de alunos');
    writeln('| 7. Sobre ');
    writeln('| 8. Sair ');
    menuLinha();
    write('ESCOLHA: ');
    readln(escolha);

    menuPrincipal := escolha;
End;

{ Menu para escolha do aluno a ser removido }
Function menuExcluirAluno: Integer;
Begin
    ClrScr();
    menuCabecalho('Excluir aluno');
    writeln('| 1. Por código');
    writeln('| 2. Por nome');
    writeln('| 3. Por status (exclusão lógica)');
    menuLinha();
    write('>> Selecione o método de exclusão:');
    read(escolha);

    menuExcluirAluno := escolha;
End;

{ Grava um registro no arquivo }
Procedure gravarRegistro();
Begin
    write(arqAlunos, alunoMem);    
    writeln('>> Aluno cadastrado');
    mensagemContinuar();
End;

{ Valição de números inteiros negativos }
Function validarNegativoInt(campo: String): Integer;
Var
    entrada: Integer;
    confirmacao: Boolean;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        if entrada < 0 then
            Begin
                write('Valores negativos não são permitidos');
                mensagemContinuar();
            End
        Else
            Begin
                confirmacao := true;
            End;

    Until confirmacao = true;

    validarNegativoInt := entrada;
End;

{ Validação de números reais negativos }
Function validarNegativoReal(campo: String): Real;
Var
    entrada: Real;
    confirmacao: Boolean;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        if entrada < 0 then
            Begin
                write('Valores negativos não são permitidos');
                mensagemContinuar();
            End
        Else
            Begin
                confirmacao := true;
            End;

    Until confirmacao = true;

    validarNegativoReal := entrada;
End;

{ Valida a quantidade de caracateres no nome do aluno }
Function validarCaracteres(campo: String; tamanho: Integer): String;
Var
    entrada: String;
    confirmacao: Boolean;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        if length(entrada) > tamanho then
            Begin
                writeln('ERRO são permitidos apenas ', tamanho, ' caracteres para este campo');
                mensagemContinuar();
            End
        Else
            Begin
                confirmacao := true;
            End;

    Until confirmacao = true;

    validarCaracteres := entrada;
End;

{ Valida a entrada de um caractere 'binário' [S/N] com base em uma lista }
{ Atenção: o posições }
Function validarLista(campo: String; valoresValidos: CaracteresValidos; tamanhoLista: Integer): Char;
Var
    entrada: Char;
    confirmacao: Boolean;
    i: Integer;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write(campo);
        readln(entrada);

        for i := 0 to (tamanhoLista - 1) do
        Begin
            if valoresValidos.lista[i] = entrada then
                confirmacao := true;
        End;

        if not confirmacao then
        Begin
            writeln('Dados inválidos. Digite novamente.');
            mensagemContinuar();
        End;

    Until confirmacao = true;

    validarLista := UpCase(entrada);
End;

{ Interface para cadastro de um novo aluno }
Procedure incluirAluno();
Begin
    seek(arqAlunos, filesize(arqAlunos));

    menuCabecalho('CADASTRAR ALUNO');

    alunoMem.cod    := validarNegativoInt('Código: ');
    alunoMem.nome   := validarCaracteres('Nome: ', 80);
    alunoMem.idade  := validarNegativoInt('Idade: ');
    alunoMem.sexo   := validarLista('Sexo do aluno [M-asculino/F-eminino]: ', sexoValido, 4);
    alunoMem.status := validarLista('Status do aluno [A-Ativo/I-nativo]: ', statusValido, 4);

    gravarRegistro(); 
End;

{ Imprime o aluno da variável alunoMem }
Procedure imprimeAluno();
Begin
    menuLinha();
    writeln('Código: ', alunoMem.cod);
    writeln('Nome..: ', alunoMem.nome);
    writeln('idade.: ', alunoMem.idade);
    writeln('Status: ', alunoMem.status);
End;


{ Verifica se um aluno existe no arquivo e carrega para a memória }
Function encontrarAluno(codigo: Integer): Boolean;
Begin
    encontrarAluno := true;
End;

{ Encontra um aluno pelo código e carrega para a variável de memória }
Function pesquisarAlunoCod(): Boolean;
Var
    codigo: Integer;
    alunoEncontrado: Boolean;
Begin
    alunoEncontrado := false;
    codigo := validarNegativoInt('Código do aluno: ');

    seek(arqAlunos, 0);

    while (not eof(arqAlunos)) do
    Begin
        read(arqAlunos, alunoMem);

        if alunoMem.cod = codigo then
        begin
            alunoEncontrado := true;
            break;
        End;
    End;

    menuLinha();
    mensagemContinuar();
    
    pesquisarAlunoCod := alunoEncontrado;
End;

{ Encontra um aluno pelo nome e carrega para a variável de memória }
Procedure pesquisarAlunoNome();
Begin

End;

Procedure editarAluno();
Begin
    ClrScr();
    menuCabecalho('Você editará o aluno ');
    writeln('Código: ', alunoMem.cod);
    mensagemContinuar();

    alunoMem.nome := validarCaracteres('Nome: ', 80);
    alunoMem.idade := validarNegativoInt('Idade: ');
    alunoMem.status := validarLista('Status do aluno [A-Ativo/I-nativo]: ', statusValido, 4);

    gravarRegistro();
End;

{ Altera as informações de cadastro de um aluno }
Procedure alterarDadosAluno();
Var
    opcaoValida, alunoEncontrado: Boolean;
    escolha: Char;
Begin
    opcaoValida := false;

    Repeat
        ClrScr();
        menuCabecalho('ALTERAR DADOS DO ALUNO');
        
        alunoEncontrado := pesquisarAlunoCod();
        
        if not alunoEncontrado then
            opcaoValida := true
        else
            begin
                writeln('Aluno não encontrado. Deseja procurar outro? S/N');
                read(escolha);

                if (escolha = 'n') OR (escolha = 'N') then
                    opcaoValida := true;
            end;
    Until opcaoValida = true;


    if alunoEncontrado then
        editarAluno();

    menuLinha();
    mensagemContinuar();
End;

{ Exclui um aluno com base no código }
Procedure excluirAlunoCod();
Var
    codigo: Integer;
Begin
    
End;

{ Exclui um aluno com base no nome }
Procedure excluirAlunoNome();
Var
    nome: String;
Begin
    
End;

Procedure excluirAlunoStatus();
Begin

End;

{ Exclui um aluno por ID, nome ou status (inativo/ativo) }
Procedure excluirAluno();
Var
    opcaoValida: Boolean;
Begin
    opcaoValida := false;

    Repeat 
        escolha := menuExcluirAluno();

        case escolha of
            1: excluirAlunoCod();
            2: excluirAlunoNome();
            3: excluirAlunoStatus();
        else
            opcaoInvalida();
        end;

    Until opcaoValida = true;
End;


{ Relatório dos alunos cadastrados }
Procedure relatorioAlunos();
Begin
    seek(arqAlunos, 0);

    ClrScr();
    menuCabecalho('ALUNOS CADASTRADOS');

    while not eof(arqAlunos) do
    Begin
        read(arqAlunos, alunoMem);
        imprimeAluno();
    End;
    menuLinha();
    mensagemContinuar();
End;

{ Informações sobre o programa}
Procedure sobre(); 
Begin
    writeln('Acadêmico: Nathanael Cavalcanti Bonfim - 2020');
    writeln('Disciplina: Algoritmos');

End;

BEGIN

    inicializarGlobais();
    configArquivo();

    Repeat 
        
        escolha := menuPrincipal;

        case escolha of
            1: incluirAluno();
            2: alterarDadosAluno();
            3: excluirAluno();
            4: pesquisarAlunoCod();
            5: pesquisarAlunoNome();
            6: relatorioAlunos();
            7: sobre();
            8: encerrarPrograma();
        else
            opcaoInvalida();
        end;
        
    Until escolha = 5;
    
END.
