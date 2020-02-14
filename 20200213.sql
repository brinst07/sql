--synonym : ���Ǿ�
--1. ��ü ��Ī�� �ο�
--    -> �̸��� �����ϰ� ǥ��
--    
--SEM ����ڰ� �ڽ��� ���̺� emp���̺��� ����ؼ� ���� v_emp view
--hr ����ڰ� ����� �� �ְ� �� ������ �ο�

--v_emp : �ΰ��� ���� sal, comm�� ������ view

--hr ����� : v_emp�� ����ϱ� ���� ������ ���� �ۼ�
--�߿��� ������ �ƴ����� �˾Ƶ���!!!

SELECT *
FROM brinst.v_emp;

--synonym brinst.v_emp --> v_emp
--v_emp == brinst.v_emp

SELECT *
FROM v_emp;

1. brinst �������� v_emp�� hr�������� ��ȸ�� �� �ֵ��� ��ȸ������ �ο�
grant select on v_emp to hr;

2. hr ���� v_emp ��ȸ�ϴ°� ����(���� 1������ �޾ұ� ������)
    ���� �ش� ��ü�� �����ڸ� ��� : brinst.v_emp
    �����ϰ� brinst.v_emp -> v_emp�� ����ϰ� ���� ��Ȳ
    synonym ����
    
3. CREATE SYNONYM [�ɼ�] �ó���̸� FOR �� ��ü��;
[option] : public, private
�Ϲ������� private�� ��� �̴� default���̴�.

4. DROP SYNONYM �ó���̸�
--brinst������ �ִ� view�̴�.
SELECT *
FROM brinst.v_emp;

--synonym�� ������ֱ� ������ �ȵ� 
--synonym�� v_emp�� ������ָ� �� ����ȴ�.
SELECT *
FROM v_emp;

CREATE SYNONYM v_emp FOR brinst.v_emp;


--DCL

GRANT CONNECT TO brinst;
GRANT SELECT ON ��ü�� TO HR; 

--��ü���� ���� ��Ű��!

--���� ����
--1. �ý��� ���� : TABLE�� ����, VIEW ���� ����...
--2. ��ü ���� : Ư�� ��ü�� ���� SELECT, UPDATE, INSERT, DELETE....
--
--ROLE : ������ ��� ���� ����
--����� ���� ���� ������ �ο��ϰ� �Ǹ� ������ �δ�.
--Ư�� ROLE�� ������ �ο��ϰ� �ش� ROLE ����ڿ��� �ο�
--�ش� ROLE�� �����ϰ� �Ǹ� ROLE�� ���� �ִ� ��� ����ڿ��� ����
--
--���� �ο�/ȸ��
--�ý��� ���� : GRANT �����̸� TO ����� | ROLE ;
--              REVOKE �����̸� FROM ����� | ROLE;
--�ý��۱����� ���������� ȸ���� �ȵȴ�.
--
--��ü ���� : GRANT �����̸� ON ��ü�� TO ����� | ROLE;
--            REVOKE �����̸� ON ��ü�� FROM ����� | ROLE;
--��ü ������ ���������� ȸ���� �ȴ�.


--data dictionary : ����ڰ� �������� �ʰ�, dbms�� ��ü������ �����ϴ� �ý��������� ���� view
--
--data dictionary  ���ξ�
--1. USER : �ش� ����ڰ� ������ ��ü
--2. ALL : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷκ��� ������ �ο����� ��ü
--3. DBA : ��� ������� ��ü
--
-- V$ Ư�� VIEW -> ���� �ý��� ���� view 

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES;
--�Ϲ� ����ڴ� ���� ����.

--DICTIONARY ���� Ȯ�� : SYS.DICTIONARY

SELECT *
FROM DICTIONARY;

--��ǥ���� dictionary
--OBJECTS : ��ü������ȸ(���̺�, �ε���, VIEW, SYNONYM ..)
--TABLES : ���̺� ������ ��ȸ
--TAB_COLUMNS : ���̺��� �÷� ���� ��ȸ
--INDEXES : �ε��� ���� ��ȸ -> �����ȹ�� �߿��� ����
--IND_COLUMNS : �ε��� ���� �÷� ��ȸ -> �����ȹ�� �߿��� ����
--CONSTRAINTS : ���� ���� ��ȸ
--CONS_COLUMNS : ���� ���� ���� �÷� ��ȸ
--TAB_COMMENTS : ���̺� �ּ� -> ���̺� �ּ� �ٴ� ���� �⸣��
--COL_COMMENTS : ���̺��� �÷� �ּ� -> �ּ��ٴ� ���� �⸣��

SELECT *
FROM USER_OBJECTS;

--emp, dept ���̺��� �ε����� �ε��� �÷� ���� ��ȸ
--user_indexes, user_ind_columns join
--���̺��, �ε�����, �÷���
--    emp    ind_n_emp_04 ename �̷������� ���;���

SELECT *
FROM USER_indexes;

SELECT *
FROM user_ind_columns;


SELECT i.table_name, i.index_name, c.column_name, c.column_position
FROM user_indexes i, user_ind_columns c
WHERE i.index_name = c.index_name;

SELECT table_name, index_name, column_name,column_position
FROM user_ind_columns
ORDER BY table_name, index_name, column_position;

--SQL ����

--multiple insert : �ϳ��� insert �������� ���� ���̺� �����͸� �Է��ϴ� DML

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;

--������ ���� ���� ���̺� ���� �Է��ϴ� multiple insert

INSERT ALL 
    INTO dept_test
    INTO dept_test2
SELECT 98,'���','�߾ӷ�' FROM dual UNION ALL
SELECT 97,'IT','����' FROM dual;


���̺� �Է��� �÷��� �����Ͽ� multiple insert;
ROLLBACK;
INSERT ALL 
    INTO dept_test (deptno, loc) VALUES (deptno,loc)
    INTO dept_test2
SELECT 98 deptno,'���' dname,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97 ,'IT','����' FROM dual;

--�� ������ ����Ұ��� �׷��� ������ �ʴ�. �̷� ����� ����ϴ� ���� ���� ���谡 �߸��Ǿ��� ����̴�.

--���̺� �Է��� �����͸� ���ǿ� ���� multiple insert

CASE  
    WHEN ���� ��� THEN
END;

ROLLBACK;
INSERT ALL 
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES (deptno,loc)
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno,'���' dname,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97 ,'IT','����' FROM dual;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;

--������ �����ϴ� ù��° insert�� �����ϴ� multiple insert

ROLLBACK;
����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
���̺� �̸������ϳ� ���� ������ ���� ����Ŭ ���������� ������ �и��� ������ �����͸� ����

dept_test ==> dept_test_20200201
INSERT FIRST 
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES (deptno,loc)
    WHEN deptno >= 97 THEN
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno,'���' dname,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97 ,'IT','����' FROM dual;

--
--MERGE : ����
--���̺� �����͸� �Է�/���� �Ϸ��� ��
--1. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ� 
--   -> ������Ʈ
--2. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������
--   -> INSERT
--   
--
--1.SELECT ����
--2-1.SELECT ���� ����� 0 ROW �̸� INSERT
--2-2.SELECT ���� ����� 1 ROW �̸� UPDATE
--
--MERGE ������ ����ϰ� �Ǹ� SELECT�� ���� �ʾƵ� �ڵ����� ������ ������ ����
--INSERT Ȥ�� UPDATE�� �����Ѵ�.
--2���� ������ �ѹ����� �ش�.
--
--MERGE INTO ���̺�� [alias]
--USING (TABLE | VIEW | IN-LINE-VIEW)
--ON (��������)
--WHEN MATCHED THEN
--    UPDATE SET col= �÷���, col2= �÷���.......
--WHEN NOT MATCHED THEN
--    INSERT (�÷�1, �÷�2....) VALUES (�÷���1, �÷���2....);
    

SELECT *
FROM emp_test;

SELECT *
FROM dept_test;

INSERT INTO dept_test (deptno) VALUES (10);
ALTER TABLE emp_test ADD COLUMNS (hp number(10));

�α׸� �ȳ���� -> ������ �ȵȴ� -> �׽�Ʈ������ ���..
TRUNCATE TABLE emp_test;

���̺��� emp_test���̺�� ����(7369-SMITH)

INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno=7782;

select *
from emp;
where empno=7369;

ALTER TABLE emp_test ADD (hp varchar2(20));


ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT *
FROM emp_test;

UPDATE emp_test SET ename = 'brown'
WHERE empno = '7782';

COMMIT

emp���̺��� ��� ������ emp_test���̺�� ����
emp���̺��� ���������� emp_test���� �������� ������ insert
emp���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� update

emp���̺� �����ϴ� 14���� �������� emp_test���� �����ϴ� 7369�� ������ 13���� �����Ͱ�
emp_test ���̺� �űԷ� �Է��� �ǰ�
emp_test�� �����ϴ� 7369���� �����ʹ� ename(brown)�� emp���̺� �����ϴ� �̸��� SMITH�� ����

MERGE INTO emp_test a
USING emp b
ON(a.empno = b.empno)
WHEN MATHCED THEN 
    UPDATE SET a.ename=b.ename,
               a.deptno = b.deptno
WHEN NOT MATCHED THEN
    INSERT (empno,ename, deptno) VALUES (b.empno, b.ename, b.deptno);
    
SELECT *
FROM emp_test;

�ش� ���̺� �����Ͱ� ������ insert, ������ update
emp_test���̺� ����� 9999���� ����� ������ ���Ӱ� insert
������ update
(9999,'brown',10,'010')


INSERT INTO dept_test VALUES(9999,'brown',10,'010');
UPDATE dept_test SET ename = 'brown'
                     deptno = 10
                     hp = '010'
WHERE empno = 9999;

MERGE INTO emp_test
USING dual
ON(empno =9999)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown',
               deptno = 10,
               hp = '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999,'brown',10,'010');
    
SELECT 
FROM(SELECT deptno, SUM(sal)
     FROM emp
     GROUP BY deptno)a;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
UNION
select null ,sum(sal) 
FROM emp;



--I/O
--CPU CACHE > RAM > SSD > HDD > NETWORK

--REPORT GROUP FUNCTION
--ROLLUP
--CUBE
--GROUPING

--ROLLUP
--����� : GROUP BY ROLLUP (�÷�1, �÷�2..)
--SUBGROUP�� �ڵ������� ����
--SUBGROUP�� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� �����ʿ������� �ϳ��� �����ϸ鼭 SUB GROUP�� ����
--EX : GROUP BY ROLLUP(deptno)
----> 
--ù��° sub group : GROUP BY DEPTNO
--�ι�° sub group : GROUP BY NULL -> ��ü ���� ���
--
--GROUP_AD1�� GROUP BY ROLLUP���� ����Ͽ� �ۼ�

SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP(deptno);

SELECT job, deptno, sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--1. GROUP BY ROLLUP (job, deptno); -> ������, �μ��� �޿���
--2. GROUP BY ROLLUP (job); -> �������� �޿���
--3. GROUP BY ROLLUP ; -> ��ü �޿���

SELECT CASE
        WHEN grouping(job) =1 AND grouping(deptno) =1 THEN '�Ѱ�'
        ELSE job
        END JOB, 
        CASE
        WHEN grouping(deptno) =1 THEN 1234569
        ELSE deptno
        END deptno, sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT 
DECODE(grouping(job),1, DECODE(grouping(deptno),1,'�Ѱ�'),
       job) job,
        deptno, sum(sal+nvl(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);

desc emp;

SELECT  CASE
        WHEN grouping(job) =1 AND grouping(deptno) =1 THEN '��'
        ELSE job
        END JOB, 
        CASE
        WHEN TO_CHAR(grouping(deptno)) ='1' THEN CASE WHEN TO_CHAR(grouping(job)) ='1' then '��' ELSE '�Ұ�' END                           
        ELSE TO_CHAR(deptno)
        END deptno,
        sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


SELECT 1 ,'brown'
FROM dual
UNION ALL
SELECT 1 , 'sally'
FROM dual;
