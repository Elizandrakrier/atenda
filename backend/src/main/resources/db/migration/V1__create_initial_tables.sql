CREATE TABLE usuario (
                         id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                         nome        VARCHAR(120) NOT NULL,
                         email       VARCHAR(150) NOT NULL UNIQUE,
                         senha       VARCHAR(100) NOT NULL,
                         perfil      VARCHAR(20)  NOT NULL,
                         ativo       BOOLEAN      NOT NULL DEFAULT TRUE,
                         criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chamado (
                         id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
                         titulo              VARCHAR(100)  NOT NULL,
                         descricao           VARCHAR(2000) NOT NULL,
                         status              VARCHAR(30)   NOT NULL,
                         categoria           VARCHAR(30)   NOT NULL,
                         prioridade          VARCHAR(20)   NOT NULL,
                         triagem_confirmada  BOOLEAN       NOT NULL DEFAULT FALSE,
                         cliente_id          BIGINT        NOT NULL,
                         atendente_id        BIGINT        NULL,
                         prazo_sla           DATETIME      NOT NULL,
                         pausado_desde       DATETIME      NULL,
                         minutos_pausados    INT           NOT NULL DEFAULT 0,
                         em_risco            BOOLEAN       NOT NULL DEFAULT FALSE,
                         sla_estourado       BOOLEAN       NOT NULL DEFAULT FALSE,
                         criado_em           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         resolvido_em        DATETIME      NULL,
                         fechado_em          DATETIME      NULL,
                         CONSTRAINT fk_chamado_cliente   FOREIGN KEY (cliente_id)   REFERENCES usuario (id),
                         CONSTRAINT fk_chamado_atendente FOREIGN KEY (atendente_id) REFERENCES usuario (id)
);

CREATE TABLE mensagem (
                          id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                          chamado_id  BIGINT        NOT NULL,
                          autor_id    BIGINT        NOT NULL,
                          texto       VARCHAR(2000) NOT NULL,
                          origem_ia   VARCHAR(20)   NOT NULL DEFAULT 'NAO',
                          enviada_em  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          CONSTRAINT fk_mensagem_chamado FOREIGN KEY (chamado_id) REFERENCES chamado (id),
                          CONSTRAINT fk_mensagem_autor   FOREIGN KEY (autor_id)   REFERENCES usuario (id)
);

CREATE TABLE avaliacao (
                           id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                           chamado_id   BIGINT       NOT NULL UNIQUE,
                           nota         TINYINT      NOT NULL,
                           comentario   VARCHAR(500) NULL,
                           avaliado_em  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           CONSTRAINT fk_avaliacao_chamado FOREIGN KEY (chamado_id) REFERENCES chamado (id),
                           CONSTRAINT chk_avaliacao_nota   CHECK (nota BETWEEN 1 AND 5)
);