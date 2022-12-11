schema={
    {"C","O","I","H","C","C","E","P","S","B"},
    {"I","N","O","I","Z","I","R","F","I","A"},
    {"E","D","E","N","T","I","A","G","A","C"},
    {"T","E","C","A","S","C","O","R","O","C"},
    {"N","O","H","P","M","D","U","I","N","O"},
    {"E","S","A","E","I","T","L","N","I","N"},
    {"N","P","N","N","N","G","A","O","D","C"},
    {"A","A","I","I","A","O","C","I","N","I"},
    {"M","Z","T","T","I","M","C","Z","A","A"},
    {"R","Z","E","T","I","O","A","O","V","T"},
    {"E","O","R","E","L","L","S","L","A","U"},
    {"P","L","A","P","I","E","G","A","L","R"},
    {"M","A","N","I","C","U","R","E","R","E"}
    }



elenco = {"ACCONCIATURE","BIGODINI","CASCO","DENTI","FRIZIONI",
"LACCA","LAVANDINO","LOZIONI","MANICURE","ONDE","PERMANENTE",
"PETTINE","PHON","PIEGA","RASOI","RETINA","SPAZZOLA",
"SPECCHIO","TAGLIO","TINTURA"}

alfabeto = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}

-- fa il print di una table in maniera figa
local function printt(tbl)
    for k,v in pairs(tbl) do   
            print("["..k.."]",table.unpack(v))
    end
end

-- shape di una tabella
local function righe(tbl) return #tbl end
local function colonne(tbl) return #tbl[1] end


-- per tables monodimensionali
local function contains(tbl,val,i)
    i = i or 1
    if tbl[i] == val then return true end
    if i == #tbl then return false end
    return contains(tbl,val,i+1)
end

-- per tables bidimensionali (non usata, definita solo per curiosita)
local function contains_bi(tbl,val,i,j)
    i = i or 1
    j = j or 1
    if i == righe(tbl) and j == colonne(tbl) then i = 1 j = 1 return false end
    if tbl[i][j] == val then i = 1 j = 1 return true end
    if j == colonne(tbl) then j=1 i=i+1 end 

    return contains_bi(tbl,val,i,j+1) 
end

-- verifica se tutti i caratteri dello schema sono validi
local function isValid(tbl,i,j)
    i = i or 1
    j = j or 1

    if not contains(alfabeto,tbl[i][j]) then return false end
    if i == righe(tbl) and j == #tbl[i] then i1=i j1=j i=1 j=1 return contains(alfabeto,tbl[i1][j1]) end
    if j == #tbl[i] then j=1 return isValid(tbl,i+1,j) end 

    return isValid(tbl,i,j+1) 
end


-- verifica se la shape dello schema è valido (rettangolare / quadrato)
local function isRect(tbl)
    for var = 1,#tbl do
        if #tbl[var] ~= #tbl[1] then return false end
    end
    return true
end


-- copia una tabella
local function deep_copy(tbl)
    local copia={}
    for key, value in pairs(tbl) do
        if type( value ) ~= 'table' then
            copia[key] = value
        else
            copia[key] = deep_copy(value)
        end
    end
    return copia
end


-- ritorna il primo carattere della parola
local function first(parola) return parola:sub(1,1) end 


--ritorna tutte le posizioni (coordinate) di un carattere nella tabella
-- es. per il carattere "O" -> positions={{1,2},{2,3},{4,7},...}
local function findChar(tbl,char,i,j,positions)
    i = i or 1
    j = j or 1
    positions = positions or {}
    if tbl[i][j] == char then table.insert(positions,{i,j}) end
    if i == righe(tbl) and j == #tbl[i] then i=1 j=1 to_ret = positions positions = {} return to_ret end
    if j == #tbl[i] then j=1 return findChar(tbl,char,i+1,j,positions) end
    return findChar(tbl,char,i,j+1,positions)
end

-- legge dalla table n caratteri consecutivi (ritorna la stringa che formano) a partire da un indice (i,j)
-- in altre parole, leggo dallo schema la parola che si viene a formare se parto dalla posizione i,j e leggo
-- orizzontalmente gli n caratteri successivi.
-- 1
local function read_hor_dx(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end
    
    parola = parola .. tbl[i][j]
    n = n - 1
    return read_hor_dx(tbl,i,j+1,n)
end
--print(read_hor_dx(schema,2,5,2))

-- 2
local function read_hor_sx(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end

    parola = parola .. tbl[i][j]
    n = n - 1
    return read_hor_sx(tbl,i,j-1,n)
end

-- 3
local function read_ver_up(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end

    parola = parola .. tbl[i][j]
    n = n-1
    return read_ver_up(tbl,i-1,j,n)
end

-- 4
local function read_ver_down(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end
    
    parola = parola .. tbl[i][j]
    n = n-1
    return read_ver_down(tbl,i+1,j,n)
end

-- 5
local function read_diagpos_up(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end

    parola = parola .. tbl[i][j]
    n = n-1
    return read_diagpos_up(tbl,i-1,j+1,n)
end

-- 6
local function read_diagpos_down(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end

    parola = parola .. tbl[i][j]
    n = n-1
    return read_diagpos_down(tbl,i+1,j-1,n)
end

--7 
local function read_diagneg_up(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end

    parola = parola .. tbl[i][j]
    n = n-1
    return read_diagneg_up(tbl,i-1,j-1,n)
end

--8
local function read_diagneg_down(tbl,i,j,n)
    parola = parola or ""
    if n == 0 then 
        to_ret = parola
        parola = "" 
        return to_ret    
    end

    parola = parola .. tbl[i][j]
    n = n-1
    return read_diagneg_down(tbl,i+1,j+1,n)
end



-- ci saranno 8 direzioni per oscurare a partire da una posizione i,j per n posizioni successive
-- dove n è la lunghezza della parola da oscurare
--1
local function oscura_hor_dx(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_hor_dx(tbl,i,j+1,n)
end

--2
local function oscura_hor_sx(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_hor_sx(tbl,i,j-1,n)
end

--3
local function oscura_ver_up(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_ver_up(tbl,i-1,j,n)
end

--4
local function oscura_ver_down(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_ver_down(tbl,i+1,j,n)
end

--5
local function oscura_diagpos_up(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_diagpos_up(tbl,i-1,j+1,n)
end

--6
local function oscura_diagpos_down(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_diagpos_down(tbl,i+1,j-1,n)
end

--7
local function oscura_diagneg_up(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_diagneg_up(tbl,i-1,j-1,n)
end

--8
local function oscura_diagneg_down(tbl,i,j,n)
    if n == 0 then return end
    
    tbl[i][j] = "*"
    n = n - 1
    return oscura_diagneg_down(tbl,i+1,j+1,n)
end



-- La ricerca della parola inizia con l'ultima direzione e richiama le altre direzioni in caso di insuccesso
-- le altre direzioni allo stesso modo richiamano le successive fino all'ultima
-- da notare che la direzione provata richiama la direzione definita a lei sopra in caso di insuccesso 

-- 1) direzione orizzontale verso destra
-- ultima direzione provata dalla funzione force
local function hor_dx(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] + (#word-1) <= colonne(tbl) then
            if read_hor_dx(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_hor_dx(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return 0
end

-- 2) direzione orizzontale verso sinistra
local function hor_sx(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] - #word  >= 0 then
            if read_hor_sx(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_hor_sx(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return hor_dx(tbl,word)
end

-- 3) direzione verticale verso alto
local function ver_up(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[1] - #word  > 0 then
            if read_ver_up(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_ver_up(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return hor_sx(tbl,word)
end

-- 4) direzione verticale verso basso
local function ver_down(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[1] + #word -1  <= righe(tbl) then
            if read_ver_down(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_ver_down(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return ver_up(tbl,word)
end

-- 5) direzione diagonale positiva verso alto
local function diagpos_up(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] + (#word-1) <= colonne(tbl) and k[1] - #word  >= 0  then
            if read_diagpos_up(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagpos_up(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return ver_down(tbl,word) 
end

-- 6) direzione diagonale positiva verso basso
local function diagpos_down(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] - #word  >= 0 and k[1] + #word -1  <= righe(tbl)then
            if read_diagpos_down(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagpos_down(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return diagpos_up(tbl,word)
end

-- 7) direzione diagonale negativa verso alto
local function diagneg_up(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] - #word  >= 0 and (k[1] - #word  >= 0) then
            if read_diagneg_up(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagneg_up(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return diagpos_down(tbl,word)
end

-- 8) direzione diagonale negativa verso basso
-- E' l'inizio del brute force di tutte le direzioni
local function force(tbl,word)
    posix = findChar(tbl,first(word))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] + (#word-1) <= colonne(tbl) and k[1] + #word -1  <= righe(tbl) then
            if read_diagneg_down(tbl,k[1],k[2],#word) == word then
                --print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagneg_down(t,k[1],k[2],#word)
                return 1
            end
        end
    end
    return diagneg_up(tbl,word)
end

local function read_result(tbl,i,j,res)
    res = res or ""
    i = i or 1
    j = j or 1
    if i == righe(tbl) and j == #tbl[i] then print(res) return end
    if tbl[i][j] ~= "*" then res = res .. tbl[i][j] end 
    if j == colonne(tbl) then j = 1 return read_result(tbl,i+1,j,res)
    else return read_result(tbl,i,j+1,res) end
end

local function solve(schema, elenco)
    for _,word in pairs(elenco) do
        if force(schema,word) == 0 then
            --print(word.. " non trovata") 
            print("?") 
            os.exit() 
        end
    end
    return read_result(t)
end

t = deep_copy(schema)
if isValid(schema) and isRect(schema) then solve(schema,elenco) else print("?") os.exit() end