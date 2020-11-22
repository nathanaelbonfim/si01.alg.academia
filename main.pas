Program Padaria;
Uses Crt;

Type Aluno = Record
    cod: Integer;
    nome: String[80];
    valor: Double;
    qtd: Integer;
    status: Char;
End;

Var { Variáveis globais }
    alunoMem: Aluno;
    arqAlunos: File of Aluno;
    escolha: Integer;
    listaDeStatus: Array [0..3] of Char;

Procedure inicializarGlobais();
Begin
    escolha := 0;

    listaDeStatus[0] := 'A';
    listaDeStatus[1] := 'a';
    listaDeStatus[2] := 'i';
    listaDeStatus[3] := 'I';
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
    menuCabecalho('Padaria do Seu Zé');
    writeln('| 1. Incluir Aluno');
    writeln('| 2. Alterar Aluno');
    writeln('| 3. Relatório dos Alunos');
    writeln('| 4. Sobre o autor e o Programa');
    writeln('| 5. Sair ');
    menuLinha();
    write('ESCOLHA: ');
    readln(escolha);

    menuPrincipal := escolha;
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
Function validarNegativoDouble(campo: String): Double;
Var
    entrada: Double;
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

    validarNegativoDouble := entrada;
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

{ Valida a entrada do status do aluno }
Function validarStatus(lista: Array of Char): Char;
Var
    entrada: Char;
    confirmacao: Boolean;
    i: Integer;
Begin
    confirmacao := false;

    Repeat 
        ClrScr();
        write('Status do aluno [A-Ativo/I-nativo]: ');
        readln(entrada);

        for i := 0 to length(lista) do
        Begin
            if lista[i] = entrada then
                confirmacao := true;
        End;

        if not confirmacao then
        Begin
            writeln('Status inválido. Utilize "I" ou "A"');
            mensagemContinuar();
        End;

    Until confirmacao = true;

    validarStatus := UpCase(entrada);

End;

{ Interface para cadastro de um novo aluno }
Procedure incluirAluno();
Begin
    seek(arqAlunos, filesize(arqAlunos));

    menuCabecalho('ADICIONAR PRODUTO');

    alunoMem.cod := validarNegativoInt('Código: ');
    alunoMem.nome := validarCaracteres('Nome: ', 80);
    alunoMem.valor := validarNegativoDouble('Preço R$ ');
    alunoMem.qtd := validarNegativoInt('Quantidade: ');
    alunoMem.status := validarStatus(listaDeStatus);

    gravarRegistro(); 
End;

{ Imprime o aluno da variável alunoMem }
Procedure imprimeAluno();
Begin
    menuLinha();
    writeln('Código: ', alunoMem.cod);
    writeln('Nome..: ', alunoMem.nome);
    writeln('Valor.: ', alunoMem.valor:2:2);
    writeln('Qtd...: ', alunoMem.qtd);
    writeln('Status: ', alunoMem.status);
End;


{ Verifica se um aluno existe no arquivo e carrega para a memória }
Function encontrarAluno(codigo: Integer): Boolean;
Begin
    seek(arqAlunos, 0);

    while (not eof(arqAlunos)) do
    Begin
        read(arqAlunos, alunoMem);

        if alunoMem.cod = codigo then
        begin
            encontrarAluno := true;
            break;
        End;

    End;

    encontrarAluno := false;
End;

Procedure editarAluno();
Begin
    ClrScr();
    menuCabecalho('Você editará o aluno ');
    writeln('Código: ', alunoMem.cod);
    mensagemContinuar();

    alunoMem.nome := validarCaracteres('Nome: ', 80);
    alunoMem.valor := validarNegativoDouble('Preço R$ ');
    alunoMem.qtd := validarNegativoInt('Quantidade: ');
    alunoMem.status := validarStatus(listaDeStatus);

    gravarRegistro();
End;

{ Altera as informações de cadastro de um aluno }
Procedure alterarAluno();
Var
    opcaoValida, alunoEncontrado: Boolean;
    codigo: Integer;
    escolha: Char;
Begin
    opcaoValida := false;

    Repeat
        ClrScr();
        menuCabecalho('ALTERAR PRODUTO');
        
        codigo := validarNegativoInt('Código do aluno: ');
        alunoEncontrado := encontrarAluno(codigo);
        
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


{ Relatório dos alunos cadastrados }
Procedure relatorioAlunos();
Begin
    seek(arqAlunos, 0);

    ClrScr();
    menuCabecalho('PRODUTOS CADASTRADOS');

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

        Case escolha of
            1: incluirAluno();
            2: alterarAluno();
            3: relatorioAlunos();
            4: sobre();
            5: encerrarPrograma();
        else
            opcaoInvalida();
        end;
        
    Until escolha = 5;
    
END.