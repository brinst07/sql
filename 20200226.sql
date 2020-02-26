--Ʈ����
users ���̺��� ��й�ȣ�� ����� �� ����Ǳ� ���� ��й�ȣ��
users history���̺��� �̷��� �����ϴ� Ʈ���Ÿ� ����

SELECT *
FROM users;


1. users_history ���̺� ����
DESC users;

--key(�ĺ���) : �ش� ���̺��� �ش� �÷��� �ش� ���� �ѹ��� ����
CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE,
    CONSTRAINT pk_userid_mod_dt PRIMARY KEY (userid, mod_dt)
);

COMMENT ON TABLE users_history IS '����� ��й�ȣ �̷�';
COMMENT ON COLUMN users_history.userid IS '����ھ��̵�';
COMMENT ON COLUMN users_history.pass IS '��й�ȣ';
COMMENT ON COLUMN users_history.mod_dt IS '�����Ͻ�';

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('USERS_HISTORY');

--2. USERS ���̺��� PASS �÷� ������ ������ TRIGGER�� ����;

CREATE OR REPLACE TRIGGER make_history
        BEFORE UPDATE ON users --������Ʈ �ϱ����� trigger ���� ����
        FOR EACH ROW
        
        BEGIN
--            ��й�ȣ�� ���� �Ȱ�� üũ
--            ���� ��й�ȣ/ ������Ʈ �Ϸ����ϴ� �ű� ��й�ȣ
--            :OLD.�÷�    /  :NEW.�÷�
            IF :OLD.pass != :NEW.pass THEN
                INSERT INTO users_history VALUES(:NEW.userid, :OLD.pass, SYSDATE);
            END IF;
        END;
/

--3. Ʈ���� Ȯ��
    --1. USERS_HISTORY�� �����Ͱ� ���� ���� Ȯ��
    --2. USERS ���̺��� BROWN ������� ��й�ȣ�� ������Ʈ
    --3. USER_HISTORY ���̺��� �����Ͱ� ������ �Ǿ�����(trigger�� ����) Ȯ��
    --4. USERS ���̺��� brown ������� ������ ������Ʈ
    --5. users_history ���̺��� �����Ͱ� ������ �Ǿ����� Ȯ��


1.
SELECT *
FROM users_history;

2.
UPDATE USERS SET pass = 'test'
WHERE userid = 'brown';

3.
SELECT *
FROM users_history;

4.Ʈ���Ű� ���ƴ� ������ IF�������� ��й�ȣ�� �����̱� ������ users_history�� ������ �ʴ´�.
UPDATE USERS SET alias =  '����'
WHERE userid = 'brown';


ROLLBACK;

Ʈ���Ű��� ���� commit�� �� ���� �ʴ´�.


mybatis : java�� �̿��Ͽ� �����ͺ��̽� ���α׷��� : jdbc
jdbc�� �ڵ��� �ߺ��� ���ϴ�

sql�� �������غ�
sql�� �������غ�
sql�� �������غ�
sql�� �������غ�


sql����

sql���� ȯ�� close
sql���� ȯ�� close
sql���� ȯ�� close
sql���� ȯ�� close
sql���� ȯ�� close

��ó�� ������ �����ϴ� �κ��� 1���ε� �غ��  �ݴ� ������ �ſ� ���
mybatis���� �̷������� ��ġ�� �츮���� �Ⱥ��̰Բ� �Ѵ�.

1.���� ==> mybatis �����ڰ� ���س��� ������� �������.... -> �ַ�  pm���� �Ѵ�. �Ϲ� �����ڴ� ���� �ʴ´�.   
  sql �����ϱ� ���ؼ��� .. dbms�� �ʿ�(�������� �ʿ�) ==> xml
  mybatis���� �������ִ� class�� �̿�.
  sql�� �ڹ� �ڵ忡�ٰ� ���� �ۼ� �ϴ°� �ƴ϶� 
  xml ������ sql�� ���Ƿ� �ο��ϴ� id�� ���� ����
  
2.Ȱ�� ==> 