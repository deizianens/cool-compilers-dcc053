-- cria uma pilha vazia
class Stack inherits IO {

    (*
        empilha um valor na pilha
        retorna a pilha com o novo elemento nela
    *)
    
    push(input : String) : Stack {
        (new StackItem).init(input,self)
    };
    
    -- verifica se a pilha está vazia
    isEmpty() : Bool {
        true
    };
    
    
    -- na pilha vazia, o valor de retorno é sempre vazio
    pop() : String {
        ""
    };
    
    -- retorna topo da pilha, na pilha vazia o retorno é sempre vazio
    head() : String {
        ""
    };

    -- retorna resto da pilha, sem o primeiro elemento
    tail() : Stack {
        self
    };

    -- mostra conteudo da pilha
    show() : Stack {
        self
    };

};


-- representa um item na pilha
class StackItem inherits Stack {
    
    -- valor do topo da pilha
    headItem : String;

    -- pilha sem o primeiro elemento
    stackTail : Stack;
    
    isEmpty() : Bool {
        false
    };
    
    head() : String {
        headItem
    };

    tail() : Stack {
        stackTail
    };

    (*  
        cria um novo item na pilha com os seguintes parametros:
        - s: valor a ser empilhado
        - stack: pilha existente
        retorna nova pilha
    *)
    init(s : String, stack : Stack) : Stack {
        {
            headItem <- s;
            stackTail <- stack;
            self;
        }
    };

    (*
        retira o item do topo da pilha, guarda-o em uma variavel auxiliar (currentHead) e atualiza os itens da pilha
        retorna o valor retirado
    *)
    pop() : String {
        let currentHead : String <- headItem in
        {
            headItem <- stackTail.head();
            stackTail <- stackTail.tail();
            currentHead;
        }
    };

    -- exibe conteudo da pilha
    show() : Stack {
        {
            if not headItem = ""
            then out_string(headItem.concat("\n"))
            else false
            fi;
            stackTail.show();
            self;
        }
    };

};

-- comandos da pilha
class Command inherits IO {

    -- guarda se ainda estão aceitando inputs
    acceptingInputs : Bool <- true;

    acceptsInput() : Bool {
        acceptingInputs
    };

    parseCommand(input : String) : Command {
        {
            if input = "e"
            then (new EvaluateCommand)
            else if input = "d"
            then (new DisplayCommand)
            else if input = "x"
            then (new StopCommand)
            else (new PushCommand)
            fi fi fi;
        }
    };

    -- converte string em integer
    
    atoi(input_string : String) : Int {
		let result : Int <- 0, i : Int <- 0 in
		{
			while i < input_string.length()
			loop
			{
				result <- result * 10 + convInt(input_string.substr(i,1));
				i <- i + 1;
			}
			pool;
			result;
		}
	};

    convInt(input : String) : Int {
		let result : Int <- 0 in
		{
			if input = "1" then result <- 1 else
			if input = "2" then result <- 2 else
			if input = "3" then result <- 3 else
			if input = "4" then result <- 4 else
			if input = "5" then result <- 5 else
			if input = "6" then result <- 6 else
			if input = "7" then result <- 7 else
			if input = "8" then result <- 8 else
			if input = "9" then result <- 9 else
			result <- 0
			fi fi fi fi fi fi fi fi fi;
			result;
		}
	};

   -- calcula modulo de um número 
    mod(a : Int, b : Int) : Int {
		let q : Int, r : Int in
		{
			if b = 0
			then 0
			else
			{
				q <- a / b;
				r <- a - b * q;
				r;
			}
			fi;
		}
	};

    -- converte integer em string
    
    itoa(input : Int) : String {
		let result : String <- "", r : Int in
		{
			if input = 0
			then result <- "0"
			else
			{
				while 0 < input
				loop
				{
					r <- mod(input,10);
					result <- convString(r).concat(result);
					input <- input / 10;
				}
				pool;
			}
			fi;
			result;
		}
	};
  
    convString(input : Int) : String {
		let result : String in
		{
			if input = 1 then result <- "1" else
			if input = 2 then result <- "2" else
			if input = 3 then result <- "3" else
			if input = 4 then result <- "4" else
			if input = 5 then result <- "5" else
			if input = 6 then result <- "6" else
			if input = 7 then result <- "7" else
			if input = 8 then result <- "8" else
			if input = 9 then result <- "9" else
			result <- "0"
			fi fi fi fi fi fi fi fi fi;
			result;
		}
	};

    -- avalia comando (criada para ser utilizada em outras classes)
    evaluateCommand(stack : Stack, input : String) : Stack {
        stack
    };
};

-- classe para avaliar topo da pilha
class EvaluateCommand inherits Command {

    evaluateCommand(stack : Stack, input : String) : Stack {
        let topValue : String, oneFromTop : String, twoFromTop : String in
        {
            topValue <- stack.pop();
            oneFromTop <- stack.pop();
            twoFromTop <- stack.pop();
            if headItem = "+"
            then stack.push(itoa(atoi(oneFromTop) + atoi(twoFromTop)))
            else if headItem = "s"
            then stack.push(oneFromTop).push(twoFromTop)
            else stack.push(twoFromTop).push(oneFromTop).push(headItem)
            fi fi;
        }
    };
};

-- classe para comandos de empilhar
class PushCommand inherits Command {

    evaluateCommand(stack : Stack, input : String) : Stack {
        stack.push(input)
    };
};

-- classe para comandos de exibição
class ShowCommand inherits Command {

    evaluateCommand(stack : Stack, input : String) : Stack {
            stack.show()
    };
};

-- para execução de comandos
class StopCommand inherits Command {

    -- para a execução do programa setando acceptingInputs para false
    evaluateCommand(stack : Stack, input : String) : Stack {
        {
            acceptingInputs <- false;
            stack;
        }
    };
};


class Main inherits IO{

    stackCommand : Command <- new Command;
    
    currentStackCommand : Command <- new Command;

   -- representa nova pilha
    stack : Stack <- new Stack;

    -- item a ser empilhado
    s : String;

    main() : Object {
        while currentStackCommand.acceptsInput()
        loop
        {
            out_string(">");
            s <- in_string();
            currentStackCommand <- stackCommand.parseCommand(s);
            stack <- currentStackCommand.evaluateCommand(stack,s);
        }
        pool
    };
};
