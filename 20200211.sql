--��������Ȯ�ι��
--    1. tool
--    2. dictionary view
--    �������� : USER_CONSTRAINTS
--    ��������-�÷� : USER_CONS_COLUMNS
--    ���������� ��� �÷��� ���õǾ� �ִ��� �˼� ���� ����
--    1����ȭ

-- fk ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε���(uk,pk�� �־�� �ε��� ����)�� �����ؾ��Ѵ�.

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP','DEPT','EMP_TEST','DEPT_TEST');

--EMP, DEPT PK, FK ������ �������� ����

ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);


SELECT *
FROM member;

--���̺�, �÷� �ּ� : DICTIONARY Ȯ�� ����
--���̺� �ּ� : USER_TAB_COMMENTS
--�÷� �ּ� : USER_COL_COMMENTS
--�ּ� ���� 
--���̺� �ּ�: COMMENT ON TABLE ���̺�� IS '�ּ�';
--�÷� �ּ� : COMMENT ON COLUMN ���̺�.�÷� IS '�ּ�';

--emp : ����
--dept : �μ�


COMMENT ON TABLE emp IS '����';
COMMENT ON TABLE dept IS '�μ�';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');

--DEPT    DEPTNO : �μ���ȣ
--DEPT    DNAME : �μ���
--DEPT    LOC : �μ���ġ
--EMP     EMPNO : ������ȣ
--EMP     ENAM :  �����̸�
--EMP     JOB   : ������
--EMP     MGR  : �Ŵ��� ������ȣ
--EMP     HIREDATE : �Ի�����
--EMP     SAL  :  �޿�
--EMP     COMM  :  ������
--EMP     DEPTNO  : �ҼӺμ���ȣ

COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.LOC IS '�μ���ġ';
COMMENT ON COLUMN emp.empno IS '������ȣ';
COMMENT ON COLUMN emp.ename IS '�����̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');


SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;


SELECT t.table_name,t.TABLE_TYPE,t.COMMENTS,c.COLUMN_NAME,c.COMMENTS
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name =c.table_name AND
t.table_name IN ('CUSTOMER','PRODUCT','CYCLE','DAILY');


--VIEW
--�÷� ����
--���� ����ϴ� ������� ��Ȱ��
--���� ���� ����

--VIEW�� QUERY��!
--TABLE ó�� DBMS�� �̸� �ۼ��� ��ü
----> �ۼ����� �ʰ� QUERY ���� �ٷ� �ۼ��� VIEW : IN-LINEVIEW --> �̸��� ���⶧���� ��Ȱ���� �Ұ��ϴ�.
--VEIW�� ���̺��̴�(x)
--
--������
--1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ��� ����)
--2. INLINE-VIEW�� VIEW�� �����Ͽ� ��Ȱ��, ���� ���� ����
--
--�������
--[OR REPLACE]--> �̸� ������������� ��ü�Ѵ�. DROP�� �����ʾƵ��ȴ�.
--
--CREATE [OR REPLACE] VIEW ���Ī [(column1, column2...)} AS
--SUBQUERY;

--emp ���̺��� 8���� �÷��� sal, comm �÷��� ������ 6�� �÷��� �����ϴ� v_emp VIEW ����

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--�̷��� ������ �߻� insufficient privileges(������� ����)
--�����ڰ� �並 �����ϴ°Ŵ� ������ �ʴ�. �ý��� �����ڰ� ���� �ϴ���

--�ý��� �������� �� �������� VIEW �������� �߰�
--GRANT CREATE VIEW TO brinst;


--���� �ζ��� ��� �ۼ���
--SELECT *
--FROM (SELECT empno, ename, job, mgr, hiredate, deptno
--      FROM emp);
      
--VIEW ��ü Ȱ��
--SELECT *
--FROM v_emp;

--emp���̺��� �μ����� ���� ==> dept ���̺�� ������ ����ϰ� ����
--���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� �����ϴ�.

--VIEW : v_emp_dept
--dname(�μ���), empno(������ȣ), ename(�����̸�), job(������), hiredate(�Ի�����);

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT d.dname,e.empno, e.ename, e.job, e.hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT *
FROM v_emp_dept;

--�ζ��� ��� �ۼ���
--SELECT *
--FROM (SELECT d.dname,e.empno, e.ename, e.job, e.hiredate
--      FROM emp e, dept d
--      WHERE e.deptno = d.deptno);
      
--VIEW Ȱ���
--SELECT *
--FROM v_emp_dept;

--SMITH ���� ���� �� v_emp_dept view �Ǽ� ��ȭ�� Ȯ��
DELETE emp
WHERE ename = 'SMITH';

--VIEW�� �������� �����͸� ���� �ʰ�, ������ �������� ���� ����(SQL)�̱� ������
--VIEW���� �����ϴ� �����ͺ��� �����Ͱ� ������ �Ǹ� VIEW�� ��ȸ ����� ������ �޴´�.
--view���� update�ϴ� ���� �幰��.


--SEQUENCE : ������ - �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü
CREATE SEQUENCE ������_�̸�
[OPTION....]
����Ģ : SEQ_���̺��;

emp ���̺��� ����� ������ ����


CREATE SEQUENCE seq_emp;
--������ ���� �Լ�
--NEXTVAL : ���������� ���� ���� ���� �� �� ���
--CURRVAL : NEXTVAL�� ����ϰ� ���� ���� �о� ���� ���� ��Ȯ��


--������ ������
--ROLLBACK�� �ϴ��� NEXTVAL�� ���� ���� ���� �������� �ʴ´�.
--NEXTVAL�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����.
SELECT seq_emp.NEXTVAL
FROM dual;


SELECT seq_emp.CURRVAL
FROM dual;


INSERT INTO emp_test VALUES(seq_emp.NEXTVAL,'james',99);

SELECT ROWID, emp.*
FROM emp;

SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACOAAH';

--index��  table�� ����
--�а� ������ ���� �ʿ��� �κи� �д���


--�ε����� ������ empno������ ��ȸ�ϴ� ���
--emp ���̺��� pk_emp ���������� �����Ͽ� empno�÷����� �ε����� �������� �ʴ� ȯ��

ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for 
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);


--emp ���̺��� empno�÷����� PK������ �����ϰ� ������ SQL�� ����
--PK : UNIQUE + NOT NULL
--    (UNIQUE �ε����� �������ش�)
--==> empno �÷����� unique �ε����� ������
--
--�ε����� SQL�� �����ϰ� �Ǹ� �ε����� ���� ���� ��� �ٸ��� �������� Ȯ��

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
--���ʹ� �а��� �����°� access�� ���� ���ϴ� �����ͷ� �ٷ�����

SELECT *
FROM emp
WHERE ename = 'SMITH';

--SELECT ��ȸ�÷��� ���̺� ���ٿ� ��ġ�� ����
--SELECT * FROM emp WHERE empno = 7782
---->
--SELECT empno FROM emp WHERE empno = 7782;


EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
-- �� �����ȹ�� ���̺� �������ϴ� ������ �����ִ� �ֳ��ϸ� �ε�����  empno�� ������⶧���� ���� �׼��� �� �ʿ䰡 ����.


--UNIQUE VS NON_UNIQUE �ε����� ���� Ȯ��
--1. PK_EMP����
--2. EMPNO �÷����� NON-UNIQUE �ε��� ����
--3. �����ȹ Ȯ��

ALTER TABLE emp DROP CONSTRAINT pk_emp;

--idx_u(n)_emp_01 --> emp���̺��� ù��° (��)����ũ
--CREATE (UNIQUE) idx_~~ ON ���̺�� (�÷���) unique ���̸� ����ũ�ε��� �Ⱥ��̸� ������ũ
CREATE INDEX idx_n_emp_01 ON emp (empno);

explain plan for
SELECT empno
FROM emp
WHERE empno = 7782;


SELECT *
FROM TABLE (dbms_xplan.display);

--|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--�� ����ũ�� index range scan�� �����ϴµ� �ε��� ��ü�� ������ũ�ϱ� ������
--�ٷ� �����ε����� �ѹ� �� �о��, ���� �ٸ����̸� �� �̻� �˻����� �ʴ´�.

--emp ���̺� job �÷��� �������� �ϴ� ���ο� non-unique �ε����� ����

CREATE INDEX idx_n_emp_01 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

--���ð����� ����
--1. emp ���̺��� ��ü �б�
--2. idx_n_emp_01(empno) �ε����� Ȱ��
--3. idx_n_emp_02(job) �ε����� Ȱ��
--��� ���� ȿ���������� ����Ŭ�� ��Ƽ�������� �Ǵ��Ѵ�.

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER';

select *
FROM TABLE (dbms_xplan.display);


