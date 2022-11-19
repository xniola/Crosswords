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

-- fa il print di una table in maniera figa
local function printt(tbl)
    for k,v in pairs(tbl) do   
            print("["..k.."]",table.unpack(v))
    end
end

-- shape di una tabella
local function righe(tbl) return #tbl end
local function colonne(tbl) return #tbl[1] end

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
t = deep_copy(schema)

-- ritorna il primo carattere della parola
local function first(parola) return parola:sub(1,1) end

--ritorna tutte le posizioni (coordinate) di un carattere nella tabella
-- es. per il carattere "O" -> positions={{1,2},{2,3},{4,7},...}
local function findChar(tbl,char)
    positions = {}
    for num_riga, riga in pairs(tbl) do
        for num_colonna, carattere in pairs(riga) do
            if carattere == char then 
                table.insert(positions,{num_riga,num_colonna})
            end
        end
    end
    return positions
end

-- legge dalla table n caratteri consecutivi (ritorna la stringa che formano) a partire da un indice (i,j)
-- in altre parole, leggo dallo schema la parola che si viene a formare se parto dalla posizione i,j e leggo
-- orizzontalmente gli n caratteri successivi.
-- 1
local function read_hor_dx(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i][j+var]
    end
    return parola
end
--print(read_hor_dx(schema,2,5,2))

-- 2
local function read_hor_sx(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i][j-var]
    end
    return parola
end

-- 3
local function read_ver_up(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i-var][j]
    end
    return parola
end

-- 4
local function read_ver_down(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i+var][j]
    end
    return parola
end

-- 5
local function read_diagpos_up(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i-var][j+var]
    end
    return parola
end

-- 6
local function read_diagpos_down(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i+var][j-var]
    end
    return parola
end

--7 
local function read_diagneg_up(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i-var][j-var]
    end
    return parola
end

--8
local function read_diagneg_down(tbl,i,j,n)
    parola = tbl[i][j]
    for var = 1,n-1 do
        parola = parola..tbl[i+var][j+var]
    end
    return parola
end



-- ci saranno 8 direzioni per oscurare a partire da una posizione i,j per n posizioni successive
-- dove n è la lunghezza della parola da oscurare
--1
local function oscura_hor_dx(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i][j+var] = "*"
    end
end

--2
local function oscura_hor_sx(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i][j-var] = "*"
    end
end

--3
local function oscura_ver_up(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i-var][j] = "*"
    end
end

--4
local function oscura_ver_down(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i+var][j] = "*"
    end
end

--5
local function oscura_diagpos_up(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i-var][j+var] = "*"
    end
end

--6
local function oscura_diagpos_down(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i+var][j-var] = "*"
    end
end

--7
local function oscura_diagneg_up(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i-var][j-var] = "*"
    end
end

--8
local function oscura_diagneg_down(tbl,i,j,n)
    for var = 0,n-1 do
        tbl[i+var][j+var] = "*"
    end
end



-- 1) direzione orizzontale verso destra
local function hor_dx(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] + (#parola-1) <= colonne(tbl) then
            if read_hor_dx(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_hor_dx(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end

-- 2) direzione orizzontale verso sinistra
local function hor_sx(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] - #parola  >= 0 then
            if read_hor_sx(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_hor_sx(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end

-- 3) direzione verticale verso alto
local function ver_up(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[1] - #parola  >= 0 then
            if read_ver_up(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_ver_up(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end

-- 4) direzione verticale verso basso
local function ver_down(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[1] + #parola -1  <= righe(tbl) then
            if read_ver_down(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_ver_down(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end

-- 5) direzione diagonale positiva verso alto
local function diagpos_up(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] + (#parola-1) <= colonne(tbl) and k[1] - #parola  >= 0  then
            if read_diagpos_up(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagpos_up(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found 
end

-- 6) direzione diagonale positiva verso basso
local function diagpos_down(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] - #parola  >= 0 and k[1] + #parola -1  <= righe(tbl)then
            if read_diagpos_down(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagpos_down(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end

-- 7) direzione diagonale negativa verso alto
local function diagneg_up(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] - #parola  >= 0 and (k[1] - #parola  >= 0) then
            if read_diagneg_up(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagneg_up(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end

-- 8) direzione diagonale negativa verso basso
local function diagneg_down(tbl,parola)
    found = 0
    posix = findChar(tbl,first(parola))
    for i,k in pairs(posix) do
        -- verifico che non sforo con l'indice
        if k[2] + (#parola-1) <= colonne(tbl) and k[1] + #parola -1  <= righe(tbl) then
            if read_diagneg_down(tbl,k[1],k[2],#parola) == parola then
                print(parola.. " trovata! (pos:"..k[1]..","..k[2]..")")
                oscura_diagneg_down(t,k[1],k[2],#parola)
                found = 1
                break
            end
        end
    end
    return found
end




-- Le altre 7 direzioni di ricerca similmente ...
-- ...
-- ...
--

local function solve(schema, elenco)
    for _,parola in pairs(elenco) do
        hor_dx(schema,parola) 
        hor_sx(schema,parola)
        ver_up(schema,parola)
        ver_down(schema,parola)
        diagpos_up(schema,parola)
        diagpos_down(schema,parola)
        diagneg_up(schema,parola)
        diagneg_down(schema,parola)
    end
end

local function read_result(tbl)
    res = ""
    for _,riga in pairs(tbl) do
        for _,value in pairs(riga) do
            if value ~= "*" then
                res = res .. value
            end
        end
    end
    return res
end

solve(schema, elenco)
-- verifico se l'oscurazione è andata bene
printt(t)
print("La parola finale è: "..read_result(t))