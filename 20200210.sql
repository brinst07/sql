--1.PRIMARY KEY �������� ������ ����Ŭ dbms�� �ش� �÷����� unique index�� �ڵ����� �����Ѵ�.
--    (��Ȯ���� UNIQUE ���࿡ ���� UNIQUE�ε����� �ڵ����� �����ȴ�. ->  unique�� �����ص� unique�ε����� ����
--     PRIMARY KEY = UNIQUE + NOTNULL
--    index : �ش��÷����� �̸� ������ �س��� ��ü
--            ������ �Ǿ��ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ �� �� �ִ�.
--            ���࿡ �ε����� ���ٸ� ���ο� �����͸� �Է��� �� �ߺ��Ǵ� ���� ã�� ���ؼ� �־��� ���
--            ���̺��� ��� �����͸� ã�ƾ� �Ѵ�.
--            ������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش� ���� ���� ������ ������ �˼� �ִ�.

--2. FOREIGN KEY  
--    �������ǵ� �����ϴ� ���̺� ���� �ִ����� Ȯ�� �ؾ��Ѵ�.
--    �׷��� �����ϴ� �÷��� �ε����� �־������  FOREIGN KEY ������ ������ �� �ִ�.

--FOREIGN KEY ������ �ɼ�
--FOREIGN KEY (���� ���Ἲ) : �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Է� �� �� �ֵ��� ����
--(ex : emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� �� �� �ִ�.

--FOREIGN KEY�� �����ʿ� ���� �����͸� �����Ҷ� ������
--� ���̺��� �����ϰ� �ִ� �����͸� �ٷ� ������ �ȵ�
--(EX : EMP.deptno ==> DEPT.deptno �÷��� �����ϰ� ���� ��
--      �μ� ���̺��� �����͸� ���� �� ���� ����) -> �ֳ� �����ϰ� �ֱ⶧����
      
SELECT *
FROM emp_test;

--emp 9999,99
--dept : 98,99
--==> 98�� �μ��� �����ϴ� emp ���̺��� �����ʹ� ����
--    99�� �μ��� �����ϴ� emp ���̺��� �����ʹ� 9999�� brown ����� ����

--    ���࿡ ���� ������ �����ϰ� �Ǹ�? ������ ���� ������ �߻��Ѵ�.
--    integrity constraint (BRINST.FK_EMP_TEST_DEPT_TEST) violated - child record found
DELETE dept_test
WHERE deptno = 99;

--    ���࿡ ���� ������ �����ϰ� �Ǹ�? ���� ������ �����ϴ� ���̺��� ���⶧���� �� ������ �ȴ�.
DELETE dept_test
WHERE deptno = 98;

--FOREIGN KEY �ɼ�
--1. ON DELETE CASCADE : �θ� ������ ���(dept) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�(emp)
--2. ON DELETE SET NULL : �θ� ���� �� ���(dept) �����ϴ� �ڽĵ������� �÷��� null�� ����

--emp_test ���̺��� drop�� �ɼ��� ������ ���� ������ ���� �׽�Ʈ

drop table emp_test;

CREATE TABLE emp_test(
    empno number(4) primary key, 
    ename varchar2(10),
    deptno number(2),
    CONSTRAINT sdf FOREIGN KEY (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE);
    
INSERT INTO emp_test VALUES(9999,'brown',99);    

--emp_test ���̺��� deptno �÷��� dept_test ���̺��� deptno �÷��� ����(ON DELETE CASCADE)
--�ɼǿ� ���� �θ����̺�(dept_test)���� �� �����ϰ� �ִ� �ڽ� �����͵� ���� �����ȴ�.
DELETE dept_test
WHERE deptno = 99;


--�ɼ��� �ο����� �ʾ��� ���� ȥ�� �����ȴ�.

FK ON DELETE SET NULL �ɼ� �׽�Ʈ
�θ� ���̺��� ������ ������ (dept_test) �ڽ����̺��� �����ϴ� �����͸� NULL�� ������Ʈ
rollback;
drop table emp_test;

SELECT *
FROM dept_test;

CREATE TABLE emp_test(
    empno number(4) primary key, 
    ename varchar2(10),
    deptno number(2),
    CONSTRAINT sdf FOREIGN KEY (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL);
    
CREATE TABLE emp_test(
    empno NUMBER(4) primary key,
    ename varchar2(10),
    deptno number(2) REFERENCES dept_TEST(deptno) ON DELETE SET NULL);
    
INSERT INTO emp_test VALUES(9999,'brown',99);

dept_test ���̺��� 99�� �μ��� �����ϰ� �Ǹ�(�θ����̺��� �����ϸ�)
99�� �μ��� �����ϴ� emp_test���̺��� 9999�� �������� deptno �÷���
FK �ɼǿ� ���� NULL�� ����

DELETE dept_test
WHERE deptno = 99;

--�θ� ���̺��� ������ ���� �� �ڽ� ���̺��� �����Ͱ� NULL�� ����Ǿ����� Ȯ��

SELECT *
FROM emp_test;

--CHECK �������� : �÷��� ���� ���� ������ ������ �� ���(���� ������)
-- �ܼ��� ���Ǹ� �����ϴ�. ������ ���� �Ұ��� -> ���� Ȱ�뵵�� ���� ����
--ex : �޿� �÷��� ���ڷ� ����, �޿��� ������ �� �� ������?
--     �Ϲ����� ��� �޿����� > 0
--     CHECK ������ ����� ��� �޿����� 0���� ū ���� �˻簡��
--     EMP ���̺��� job �÷��� ���� ���� ���� 4������ ���Ѱ���
--     'SALESMAN','PRESIDENT','ANALYST','MANAGER'
  
-- ���̺� ������ �÷� ����� �Բ� CHECK ���� ����
-- emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� CHECK �������� ����

DROP TABLE emp_test;


select *
from dept_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    sal NUMBER CHECK (sal>0),
    CONSTRAINT pk_emp_test1 PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test_dept_test1 FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

INSERT INTO emp_test VALUES (9999,'brown',99,1000);

INSERT INTO emp_test VALUES (9999,'brown',99,-1000); --check ���Ǻ��� ū ���� �Է��� �����ϴ�.


--CREATE TABLE ���̺�� AS

--SELECT ����� ���ο� ���̺�� ����
--emp ���̺��� �̿��ؼ� �μ���ȣ�� 10�� ����鸸 ��ȸ�Ͽ� �ش絥���ͷ� emp_test2���̺��� ����
--NOT null ���� ���� �̿��� ���� ������ ��������ʴ´� (�߿�)
--��� �뵵 : �����Ͱ���, ������ �����...
--�Ʒ�ó�� ��Ī ������ �����ϴ�.

CREATE TABLE emp_test2(a,b,c,) AS
    SELECT *
    FROM emp
    WHERE deptno = 10;
    
SELECT *
FROM emp_test2;

--ȸ�翡�� �̷��� ���̺��� ���� �ִ�. ���̺� �����(������ �ƴ�)
--CREATE TABLE emp_20200210 AS
--SELECT *
--FROM emp;

--TALBE ����
--�÷��߰�
--�÷� ������ ����, Ÿ�Ժ���
--�⺻�� ����
--�÷����� RENAME
--�÷��� ����
--�������� �߰�/����

--TABLE ���� 1. �÷��߰�(HP varchar2(20)
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    
    CONSTRAINT pk_emp_test1 PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test_dept_test1 FOREIGN KEY (deptno) REFERENCES dept_test (deptno));
    
--ALTER TABLE ���̺�� ADD (�ű��÷��� �ű��÷� Ÿ��);

ALTER TABLE emp_test ADD (hp varchar2(20));

DESC emp_test;

--TABLE ���� 2. �÷������� ����, Ÿ�Ժ��� -> �߻�� x
-- ex : �÷� varchar2(20) -> varchar2(5)
-- ������  �����Ͱ� ������ ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����
-- �Ϲ������� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���� �÷��� ������, Ÿ���� �߸��� ���
-- �÷�������, Ÿ���� ������
-- �����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ������(������ �ø��°͸� ����)

--ALTER TABLE ���̺�� MODIFY(���� �÷��� �ű� �÷� Ÿ��(������));

ALTER TABLE emp_test MODIFY (hp varchar(30));


-- hp varchar2(30 ->hp number

ALTER TABLE emp_test MODIFY (hp NUMBER);


-- �÷� �⺻ �� ����
--ALTER TABLE ���̺�� MODIFY (�÷��� DEFAULT �⺻��);
-- ���� �ִ� ���¿��� default�� �����ϸ� ���� �ִ� ������ �⺻���� ������� �ʰ�, ���������� ����ȴ�.

--HP NUMBER --> VARCHAR(20) DEFAULT 010
ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');

--hp �÷����� ���� ���� �ʾ����� default ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�.
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);

SELECT *
FROM emp_test;

--TABLE 4.����� �÷� ����
--�����Ϸ��� �ϴ� �÷��� FK����, PK������ �־ �������
--ALTER TABLE ���̺�� RENAME ���� �÷��� TO �ű� �÷���;

hp ==> hp_n;

ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;

-- ���̺� ���� 5. �÷� ����
--ALTER TABLE ���̺�� DROP COLUMN �÷���;
--emp_test ���̺��� hp_n �÷� ����

--emp_test�� hp_n �÷��� �ִ� ���� Ȯ��
SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;

--���� : 
--1. emp_test  ���̺��� drop�� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
--2. empno, ename, deptno 3���� �÷����� (9999,'brown',99) �����ͷ� INSERT
--3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
--4. 2���������� �Է��� �������� hp�÷� ���� ��� �ٲ���� Ȯ��

--TABLE ���� 6. �������� �߰�/����
--ALTER TABLE ���̺�� ADD/CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY, FOREIGN KEY) (�ش��÷�);
--ALTER TABLE ���̺�� DROP/CONSTRAINT �������Ǹ�;

--1. emp_test ���̺� ������
--2. �������� ���� ���̺��� ����
--3. PRIMARY KEY, FOREIGN KEY  ������ ALTER TABLE ������ ���� ����
--4. �ΰ��� �������ǿ� ���� �׽�Ʈ

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
   
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test1 PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test1 FOREIGN KEY (deptno) REFERENCES dept_test(deptno);



--primary key �׽�Ʈ
INSERT INTO emp_test VALUES(9999,'brown',99);
INSERT INTO emp_test VALUES(9999,'sally',99); --ù��° INSERT ������ ���� �ߺ��ǹǷ� ����

--FOREIGN KEY �׽�Ʈ
INSERT INTO emp_test VALUES(9998, 'sally', 98); -- dept_test ���̺� �������� �ʴ� �μ���ȣ �̹Ƿ� ����

--�������� ���� : PRIMARY KEY, FOREIGN KEY
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test1;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test1;

--���������� �����Ƿ� empno�� �ߺ��� ���� ���� �ְ�, dept_test���̺� �������� �ʴ�
--deptno ���� �� ���� �ִ�.

--�ߺ��� empno ������ �����͸� �Է�
INSERT INTO emp_test VALUES (9999,'brown',99);
INSERT INTO emp_test VALUES (9999, 'sally', 99);

--�������� �ʴ� 98�� �μ��� ������ �Է�
INSERT INTO emp_test VALUES (9998, 'sally', 98);

SELECT *
FROM emp_test;

--�������� Ȱ��ȭ/��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE /DISABLE CONSTRAINT �������Ǹ�;

--1. emp_test ���̺����
--2. emp_test ���̺� ����
--3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test.deptno)  �������� ����
--4. �ΰ��� ���������� ��Ȱ��ȭ
--5. ��Ȱ��ȭ�� �Ǿ����� insert�� ���ؼ� Ȯ��
--6. ���� ������ ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno number(5),
    ename varchar2(20),
    deptno number(5));
    
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test1 PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test1 FOREIGN KEY (deptno) REFERENCES dept_test(deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test1;
ALTER TABLE emp_test DISAblE CONSTRAINT fk_emp_test_dept_test1;

INSERT INTO emp_test VALUES(9999,'brown',99);

INSERT INTO emp_test VALUES(9999,'sally',98);
COMMIT;
--emp_test ���̺��� empno�÷��� ���� 999�� ����� �θ� �����ϱ� ������
--PRIMARY KEY���������� Ȱ��ȭ �� ���� ����.
--empno �÷��� ���� �ߺ����� �ʵ��� �����ϰ� �������� Ȱ��ȭ �� �� �ִ�.
--�ߺ� �����͸� ����
DELETE emp_test
WHERE ename = 'sally';

--�������� Ȱ��ȭ
--dept_test ���̺� �������� �ʴ� �μ���ȣ 98�� emp_test���� �����
--1.dept_test ���̺� 98�� �μ��� ����ϰų�
--2.sally�� �μ���ȣ�� 99������ �����ϰų�
--3.sally�� ����ų�

UPDATE emp_test set deptno = 99
WHERE ename = 'sally';
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test1;
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test1;

commit;

--���� : 
--1. emp_test  ���̺��� drop�� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
--2. empno, ename, deptno 3���� �÷����� (9999,'brown',99) �����ͷ� INSERT
--3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
--4. 2���������� �Է��� �������� hp�÷� ���� ��� �ٲ���� Ȯ��


drop table emp_test;
CREATE TABLE emp_test(
    empno NUMBER(5),
    ename VARCHAR2(20),
    deptno NUMBER(5),
    hp NUMBER(20));
    
INSERT INTO emp_test (empno,ename, deptno) VALUES(9999,'brown',99);

ALTER TABLE emp_test MODIFY (hp DEFAULT 010);

SELECT *
FROM emp_test;


