CREATE TABLE estoque (
    id SERIAL PRIMARY KEY,
    nome_item VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0
);

-- Função de validação de estoque
CREATE OR REPLACE FUNCTION fn_valida_estoque_minimo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantidade < 0 THEN
        RAISE EXCEPTION 'Operação cancelada! O item "%" não pode ter estoque negativo (Tentativa: % unidade(s)).', 
            NEW.nome_item, NEW.quantidade;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger vinculada
CREATE TRIGGER trg_valida_estoque
BEFORE INSERT OR UPDATE ON estoque
FOR EACH ROW
EXECUTE FUNCTION fn_valida_estoque_minimo();