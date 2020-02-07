--TRUNCATE �׽�Ʈ
-- 1. REDO �α׸� �������� �ʱ� ������ ������ ������ ������ �Ұ��ϴ�.
-- 2. DML(SELECT, INSERT, UPDATE, DELETE)�� �ƴ϶� DDL�� �з�����
--    DDL�� �з��� �ȴٴ� ���� --> ROLLBACK�� �Ұ��ϴ�. --> AUTO COMMIT

--�׽�Ʈ �ó�����
--EMP���̺� ���縦 �Ͽ� EMP_COPY��� �̸����� ���̺� ����
--EMP_COPY ���̺��� ������� TRUNCATE TABLE EMP_COPY ����

--EMP_COPY���̺� �����Ͱ� �����ϴ���  (���������� ������ �Ǿ�����)Ȯ��

--EMP_COPY ���̺� ����

CREATE TABLE emp_copy as
SELECT *
FROM emp;

TRUNCATE TABLE emp_copy;

rollback;
select *
from emp_copy;

drop table emp_copy;

--TRUNCATE TABLE ��ɾ�� DDL�̱� ������ ROLLBACK�� �Ұ��ϴ�.
--ROLLBACK �� SELECT�� �غ��� �����Ͱ� ���� ���� ���� ���� �� �� �ִ�.

--��ȭ����
--Ʈ����� : �����ܰ��� ������ �ϳ��� �۾� ������ ���� ����(������ ���� x �������� o)


-- DDL : Data Definition Language -> ������ ���Ǿ�
-- ��ü�� ����, ����, ������ ���
-- ROLLBACK �Ұ�, �ڵ� COMMIT

-- ���̺� ����
-- CREATE TABLE [��Ű����] ���̺��(�÷Ÿ�, �÷�Ÿ��[DEFAULT �⺻��], 
--                                 �÷Ÿ�2, �÷�2Ÿ��[DEFAULT �⺻��], .....);
-- ��Ű�� -> ������ ���̵�� ����(brinst, hr)....

--ranger ��� �̸��� ���̺� ����

CREATE TABLE ranger(
                    ranger_no NUMBER,
                    ranger_nm VARCHAR2(50),
                    reg_dt DATE DEFAULT SYSDATE
);

SELECT *
FROM ranger; 

INSERT INTO ranger(ranger_no,ranger_nm) VALUES(1,'brown');

commit;

-- ���̺� ����
-- DROP TABLE ���̺��;

-- ranger ���̺� ����(drop)
DROP TABLE ranger;

--DDL�� �ѹ� �Ұ�
ROLLBACK;

--������Ÿ��

--���ڿ�(varchar2, char Ÿ�� ��� ����)
--varchar2(10) : �������� ���ڿ�, ����� 1~4000byte
--               �ԷµǴ� ���� �÷� ������� �۾Ƶ� ���� ������ �������� ä���� �ʴ´�.
--char(10) : �������� ���ڿ��̴�
--           �ش� �÷��� ���ڿ��� 5byte�� �����ϸ� ������ 5byte�� �������� ä������.
--           'test' -> 'test     '  -> ���� ������ ���� ���� ����Ȯ���� ����


--����
--NUMBER(p,s) : p-��ü�ڸ��� (38), s-�Ҽ��� �ڸ���
--INTEGER ==> NUMBER(38,0)
--ranger_no NUMER ==> NUMBER(38,0)-> �⺻��

--��¥
-- DATE - ���ڿ� �ð� ������ ����
--        7BYTE

-- ��¥ -  DATE (�̰ɷ� �����ϴ� ��쵵�ְ�)
--         VARCHAR2(8) '20200207'(�̰ɷ� �ϴ� ��쵵����)
-- �� �ΰ��� �ƴϱ⶧���� ����� ���̸� ������ ������� ���̰� ���� ���� �ȴ�
-- �ϳ��� �����ʹ� 1BYTE�� ����� ���̰� ����.
-- ���� �����Ҷ� ����ؾ�������, ȸ�� ���Ը� ������Ѵ�.

-- LOB(Large Object)
-- CLOB - Character Large Object
--        VARCHAR2�� ���� �� ���� �������� ���ڿ�(4000byte�� �ʰ��ϴ� ���ڿ�)
--        ex)�� �����Ϳ��� ������ html�ڵ�

-- BLOB - BYTE Large Object
--        ������ �����ͺ��̽��� ���̺��� ������ �� 
--        �Ϲ������� �Խñ� ÷�������� ���̺����� �������� �ʰ�
--        ���� ÷�������� ��ũ�� Ư�� ������ �����ϰ�, �ش� ��θ� ���ڿ��� ����

--        ������ �ſ� �߿��� ��� : �� ������� ���Ǽ� -> ������ ���̺� ����


-- �������� : �����Ͱ� ���Ἲ(������ ������)�� ��Ű���� ���� ����
-- 1. UNIQUE ��������
--   �ش��÷��� ���� �ٸ� ���� �����Ϳ� �ߺ����� �ʵ��� ����
--   EX : ����� ���� ����� ���� ���� ����.

-- 2. NOT NULL ��������(CHECK ��������)
--     �ش��÷��� ���� �ݵ�� �����ؾ� �ϴ� ����
--     EX : ��� �÷��� NULL�� ����� ������ ���� ����.
--          ȸ�����Խ� �ʼ� �Է»��� (GITHUN���Խ� - �̸����̶�, �̸�)

-- 3. PRIMARY KEY ��������
--     UNIQUE + NOT NULL
--   EX : ����� ���� ����� ���� ���� ����, ����� ���� ����� ���� ���� ����.
--   PRIMARY KEY ���������� ������ ��� �ش� �÷����� UNIQUE INDEX�� �����ȴ�.

-- 4. FOREIGN KEY �������� (�������Ἲ)
--     �ش��÷��� �����ϴ� �ٸ� ���̺��� ���� �����ϴ� ���� �־���Ѵ�.
--     emp ���̺��� deptno�÷��� dept���̺��� deptno�÷��� ����(����)
--     emp ���̺��� deptno �÷����� dept ���̺� �������� �ʴ� �μ���ȣ�� �Է� �ɼ� ����.
--     ex : ���� dept ���̺��� �μ���ȣ�� 10,20,30,40���� ������ ���
--     emp ���̺� ���ο� ���� �߰��ϸ鼭 �μ���ȣ ���� 99������ ����� ���
--     �� �߰��� �����Ѵ�.

-- 5. CHECK �������� (���� üũ)
--     NOT NULL �������ǵ� CHECK ���࿡ ����
--     emp ���̺� JOB �÷��� ��� �ü� �ִ� ���� 'SALESMAN', 'PRESIDENT', 'CLERK'


-- �������� ���� ���
--  1. ���̺��� �����ϸ鼭 �÷��� ���
--  2. ���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���� ������ ���
--  3. ���̺� ������ ������ �߰������� ���������� �߰�

--CREATE TABLE ���̺��(
--    �÷�1 �÷� Ÿ�� [1.��������],
--    �÷�2 �÷� Ÿ�� [2. ��������],
-- 
--    [2.TABLE_CONSTRAINT]
--);


--3. ALTER TABLE emp........;


--PRIMARY KEY ���������� �÷� ������ ����(1�� ���)
--dept�� ���̺��� �����Ͽ� dept_test ���̺��� PRIMARY KEY �������ǰ� �Բ� ����
--�� �̹���� ���̺��� key�÷��� �����÷��� �Ұ�, �����÷��� ���� �����ϴ�.

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    LOC VARCHAR(13));
    
INSERT INTO dept_test (deptno) VALUES(99); -- ���������ν���ȴ�.
INSERT INTO dept_test (deptno) VALUES(99); -- �ٷ� ���� ������ ���� ���� ���� �����Ͱ� �̹� ����� -> ������ �߻�

--�������, �츮�� ���ݱ��� ������ �����dept ���̺��� deptno�÷�����
--UNIQUE�����̳� PRIMARY KEY ���������� ������ ������
--�Ʒ� �ΰ��� INSERT ������ ���������� ����ȴ�.
INSERT INTO dept (deptno) VALUES(99);
INSERT INTO dept (deptno) VALUES(99);

--�������� Ȯ�� ���
--1.  TOOL�� ���� Ȯ��
--    Ȯ���ϰ��� �ϴ� ���̺��� ����
--2.  dictionary�� ���� Ȯ�� (USER_TABLES)

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TEST';

SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'SYS_C007091';

--3.  �𵨸�(ex: exerd)���� Ȯ��

--�������� ���� ������� ���� ��� ����Ŭ���� ���������̸��� ���Ƿ� �ο� (ex. SYS_C007091)
--�������� �������� ������ 
--����Ģ�� �����ϰ� �����ϴ°� ����, � ������ ����
--PRIMARY KEY �������� : PK_���̺��
--FOREIGN KEY �������� : FK_������̺��_�������̺��


DROP TABLE dept_test;    

--�÷� ������ ���������� �����ϸ鼭 �������� �̸��� �ο�
--CONSTRAINT �������Ǹ� ��������Ÿ��(PRIMARY KEY); --> �̷����ϸ� �������� �ξ� ��������.

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR(14),
    LOC VARCHAR(13));
    

INSERT INTO dept_test (deptno) VALUES(99);
--ORA-00001: unique constraint (BRINST.SYS_C007091) violated -> �������� �̸� ������������
--ORA-00001: unique constraint (BRINST.PK_DEPT_TEST) violated -> �������� �̸��� ���� �����ذ�


2. ���̺� ������ �÷� ������� ���� �������� ���

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR(14),
    LOC VARCHAR(13),
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
    );

--NOT NULL �������� �����ϱ�
--1.  �÷��� ����ϱ�(o)
--    �� �÷��� ����ϸ鼭 �������� �ϒ׸� �ο��ϴ� �� �Ұ�

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR(14) NOT NULL,
    LOC VARCHAR(13),
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
    );
    
NOT NULL �������� Ȯ��
INSERT INTO dept_test (deptno, dname) VALUES (99,NULL);

--2. ���̺� ������ �÷� ��� ���Ŀ� ���� �����߰�

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR(14),
    LOC VARCHAR(13),
    CONSTRAINT NN_dept_test_dname CHECK (deptno IS NOT NULL)
    );

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT NN_dept_test_dname CHECK (deptno IS NOT NULL),
    dname VARCHAR(14),
    LOC VARCHAR(13)
    );
    
--UNIQUE ���� : �ش��÷����� �ߺ��Ǵ� ���� ������ ���� ����, �� NULL�� �Է��� �����ϴ�.
--PRIMARY KEY = UNIQUE + NOT NULL

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR(14) UNIQUE,
    LOC VARCHAR(13)
);

--dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');

--2. ���̺� ������ �÷��� �������� ���, �������� �̸� �ο�

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR(14) CONSTRAINT UK_dept_test UNIQUE,
    LOC VARCHAR(13)
);

--2. ���̺� ������ �÷��� �������� ������� �������� ���� -�����÷�(unique)
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT UK_dept_test_deptno_dname UNIQUE (deptno,dname)
);

--���� �÷��� ���� UNIQUE ���� Ȯ��(deptno, dname)
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO dept_test VALUES(98,'ddit','daejeon');
INSERT INTO dept_test VALUES(98,'ddit','����');

--INSERT INTO dept_test VALUES(98,'ddit','����')
--���� ���� -
--ORA-00001: unique constraint (BRINST.UK_DEPT_TEST_DEPTNO_DNAME) violated
--���� ����ũŰ ���� ������ �ٸ����� �ٲٴ��� �����߻�

--FOREIGN KEY ��������
--�����ϴ� ���̺��� �÷��� �����ϴ� ���� ��� ���̺��� �÷��� �Է��� �� �ֵ��� ����
--EX : emp ���̺� deptno �÷��� ���� �Է��� �� dept ���̺��� deptno �÷��� �����ϴ� �μ���ȣ��
--     �Է��Ҽ� �ֵ��� ����
--     �������� �ʴ� �μ���ȣ�� emp  ���̺��� ������� ���ϰԲ� ����

--1.  dept_test ���̺� ����
--2.  emp_test ���̺� ����
--    .emp_test ���̺� ������ deptno �÷����� dept.deptno �÷��� �����ϵ��� FK�� ����
    
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    LOC VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno));
    
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    CONSTRAINT PK_emp_test PRIMARY KEY (empno));
    
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno));
    
--������ �Է¼���
--emp_test ���̺� �����͸� �Է��ϴ°� �����Ѱ�??
--    .���ݻ�Ȳ(dept_test, emp_test ���̺��� ��� ����-�����Ͱ� �������� ���� ��)
INSERT INTO emp_test VALUES(9999,'brown',NULL); --FK�� ������ �÷��� NULL�� ���
INSERT INTO emp_test VALUES(9998,'sally',10); --10�� �μ��� dept_test ���̺� �������� �ʾƼ� ����

--dept_test ���̺� �����͸� �غ�
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO emp_test VALUES(9998,'sally',10); --10�� �μ��� dept_test�� �������� �����Ƿ� ����
INSERT INTO emp_test VALUES(9998,'sally',99); --99�� �μ��� dept_test�� �����ϹǷ� ���� ����


--���̺� ������ �÷� ��� ���� �������� ����

DROP TABLE emp_test;

DROP TABLE dept_test;
--dept test�� ���� ����ϸ� ������ �� �ֳ� emp�� dept�� �����ϰ� �ֱ⶧��
--���� emp ���� ����� �ؾ���
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    LOC VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno));
   
INSERT INTO dept_test VALUES(99,'ddit','daejeon');

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno));
    
INSERT INTO emp_test VALUES(9999, 'brown', 10); --dept_test ���̺� 10�� �μ��� �������� �ʾ� ����
INSERT INTO emp_test VALUES(9999, 'brown', 99); --dept_test ���̺� 99�� �μ��� �����ϹǷ� ���� ����


