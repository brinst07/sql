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


