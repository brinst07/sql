--WHERE2
--WHERE ���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�.
--SQL�� ������ ������ ������ �ִ�.
--���� : Ű�� 185�̻��̰� �����԰� 70�̻��� ������� ����
--      �����԰� 70�̻��̰� Ű�� 185�̻��� ������� ���� ���Ʒ��� ����
--      �߻��� ������� ���� --> ���� x
--������ Ư¡ : ���տ��� ������ ����.
--(1,5,10) --> (10,5,1) : �� ������ ���� �����ϴ�.
--���̺��� ������ ������� ����
--SELECT ����� ������ �ٸ����� ���� �����ϸ� ����
-->���ı�� ����(ORDER BY)

SELECT ename, hiredate
FROM emp
WHERE hiredate>=TO_DATE('19820101','YYYYMMDD') AND hiredate<=TO_DATE('19830101','YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate<=TO_DATE('19830101','YYYYMMDD') AND hiredate>=TO_DATE('19820101','YYYYMMDD');

-- IN ������
-- Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
-- �μ���ȣ�� 10�� Ȥ��(or) 20���� ���ϴ� ������ ��ȸ

SELECT empno, ename, deptno
FROM emp
WHERE deptno IN (10,20);

--IN �����ڸ� ������� �ʰ� OR ������ ���
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 OR deptno = 20;

--emp���̺��� ����̸��� SMITH JONES �� ������ ��ȸ
SELECT empno, ename, deptno
FROM emp
--WHERE ename IN('SMITH', 'JONES');
WHERE ename = 'SMITH' or ename = 'JONES';

--where ���� 1=2��� false ���� ���� ��� ���� ������ �ʴ´�.
SELECT *
FROM users
WHERE 1=1;

SELECT USERID AS ���̵� , USERNM AS �̸�, ALIAS AS ����
FROM users
WHERE userid IN ('brown','cony','sally');

--���ڿ� ��Ī ������ : LIKE, %, _
--������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ�
--�̸��� BR�� �����ϴ� ����� ��ȸ
--�̸��� R ���ڿ��� ���� ����� ��ȸ


SELECT *
FROM emp
ORDER BY ENAME DESC;

--��� �̸��� s�� �����ϴ� ��� ��ȸ
--SMITH, SMILE, SKC
--% � ���ڿ�(�ѱ���, ���� �������� �ְ�, ���� ���ڿ��� �ü��� �ִ�.)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--���ڼ��� ������ ���� ��Ī
-- _�� ��Ȯ�� �� ����
--���� �̸��� s�� �����ϰ� �̸��� ��ü ���̰� 5���� �� ����
-- S____

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--��� �̸��� S���ڰ� ���� ��� ��ȸ
--ename LIKE '%S%'

SELECT *
FROM emp
WHERE ename LIKE '%S%';

SELECT MEM_ID, MEM_NAME
FROM member
WHERE MEM_NAME LIKE '��%';

--where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name Like '%��%';

-- null �� ���� (is)
-- comm �÷��� ���� null�� �����͸� ��ȸ (WHERE=null)
SELECT *
FROM emp
WHERE COMM = null;

SELECT *
FROM emp
WHERE COMM = '';

SELECT *
FROM emp
WHERE COMM IS NULL;

--where6

SELECT *
FROM emp
WHERE comm IS NOT NULL;

SELECT *
FROM emp
WHERE comm>=0;

--����� �����ڰ� 7698, 7839 �׸��� null�� �ƴ� ������ ��ȸ
--NOT IN�� null�� ���ǿ� �������ص� �������� �ʴ´�.
--NOT IN �����ڿ����� NULL ���� ���Խ�Ű�� �ȵȴ�.
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839,NULL);


SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
AND mgr IS NOT NULL;

--WHERE7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE8
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE9
SELECT *
FROM emp
WHERE deptno NOT IN 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE10
SELECT*
FROM emp
WHERE deptno IN (20, 30) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE11
SELECT*
FROM emp
WHERE job='SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE12
SELECT*
FROM emp
WHERE job='SALESMAN' OR empno LIKE '78%';

--WHERE13
SELECT*
FROM emp
WHERE job = 'SALESMAN' OR (empno >= 7800 AND empno<7900);

-- ������ �켱����
-- *,/ �����ڰ� +,- ���� �켱������ ����.
-- 1+5*2 = 11 
-- �켱���� ���� : ()
-- AND > OR

-- emp ���̺��� ��� �̸��� SMITH �̰ų� ��� �̸��� ALLEN�̸鼭 �������� SALESMAN�� ��� ��ȸ

SELECT *
FROM emp
WHERE ename = 'SMITH' OR ename = 'ALLEN' AND job = 'SALESMAN';

--����̸��� SMITH �̰ų� ALLEN�̸鼭 �㵢������ SLAESMAN�� �����ȸ
SELECT*
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN';

--where14
SELECT*
FROM emp
WHERE job = 'SALESMAN' or empno LIKE '78%' AND hiredate>=TO_DATE('19810601','YYYYMMDD');

--����
-- SELECT*
-- FROM table
-- [WHERE]
-- ORDER BY {�÷�|��Ī|�÷��ε��� [ASC | DESC], .......}

-- emp ���̺��� ��� ����� ename �÷� ���� �������� ���� ���� ������ ����� ��ȸ�ϼ���

SELECT *
FROM emp
ORDER BY ename DESC;

--DESC emp; -- DESC : DESCRIBE
--ORDER BY ename DESC; -- DESC : DESCENDING (����)

--  emp ���̺��� ��� ������ ename�÷����� ��������, ename ���� ������� mgr �÷����� ��������
SELECT *
FROM emp
ORDER BY ename DESC, mgr ASC;

--���Ľ� ��Ī�� ���
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY year_sal;


--�÷� �ε����� ����
--java array[0]
--SQL COLUMN INDEX : 1���� ����
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY 3;

--ORDER BY �ǽ�
SELECT *
FROM dept
ORDER BY DNAME;

SELECT *
FROM dept
ORDER BY LOC DESC;

--ORDER BY1
SELECT *
FROM dept;

--ORDER BY2
SELECT*
FROM emp
WHERE comm IS NOT NULL AND comm != 0 
ORDER BY comm DESC, empno;

--ORDER BY3
SELECT *
FROM emp
WHERE mgr is not null
ORDER BY job, EMPNO DESC;

SELECT *
FROM emp
WHERE ename LIKE '[a-c]%';
