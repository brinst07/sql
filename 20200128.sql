--orderby4
--10�� Ȥ�� 30�� �μ��� ���ϴ� ���

SELECT *
FROM emp
WHERE deptno in (10,30) AND SAL > 1500
ORDER BY ename DESC;

--ROWNUM -> ����¡, ���İ� ���õ� ���� �� �� �߿��ϴ�. ���� rn�̶�� alias�� ����
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN (10,30)
AND sal > 1500;

--ROWNUM�� WHERE�������� ��밡���ϴ�.
--�����ϴ� �� =  ROWNUM =1, ROWNUM <=2 --> ROWNUM =1, ROWNUM <=N
--�������� �ʴ°� =ROWNUM =2, ROWNUM >=2 --> ROWNUM=N(N�� 1�� �ƴ� ����), ROWNUM >= N(N�� 1�� �ƴ� ����)
--ROWNUM �̹� ���������Ϳ��ٰ� ������ �ο�
--  **������1. ���� ���� ������ ����(ROWNUM�� �ο����� �ʴ� ��)�� ��ȸ�� ���� ����.
--  **������2. ORDER BY ���� SELECT �� ���Ŀ� ����
--���뵵 : ����¡ ó��(1page�� 1~15��ó�� �ο�)
--���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�Ѵ�.
--����¡ ó���� ������� : 1�������� ���, ���� ����
--emp���̺� �� row �Ǽ� : 14
--����¡�� 5���� �����͸� ��ȸ
--1page : 1~5
--2page : 6~10
--3page : 11~15
SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

--���ĵ� ����� ROWNUM�� �ο� �ϱ� ���ؼ��� IN-LINE VIW�� ����Ѵ�. 197
--�������� : 1. ���� ,2. ROWNUM �ο�
--SELECT�� *�� ����� ��� �ٸ� EXPRESSION�� ǥ���ϱ� ���ؼ� ���̺��.*�� ǥ���ؾ��Ѵ�.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

--ROWNUM -> rn
-- *page size : 5, ���ı����� ename
-- 1page : rn 1~5
-- 2page : rn 6~10
-- 3page : rn 11~15
-- npage : rn (page-1)*pageSize+1 ~ page * pagesize
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (1-1)*5+1 AND 1*5;

--ROWNUM 1
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
FROM EMP)
WHERE rn <=10;

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <=10;
-- WHERE rn <=10; �� �ȵȴ�. Ư���� ���

--ROWNUM2
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 11 AND 20;

--ROWNUM3
SELECT *
FROM
    (SELECT ROWNUM rn, e.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) 
    e)
WHERE rn between (:page-1)*:pageSize+1 AND :page*10;
--���ε� ������ �ڹٿ� �����Ҷ� ���� ����ϰ�, SQL�� ������ ���� ���ε��� �� ��������� �ʴ´�.


--DUAL ���̺� : �����Ϳ� ������� �Լ��� �׽�Ʈ �غ� �������� ���
--�ٸ� DBMS������SQL SERVER������ SELECT �������ε� ���డ���ϵ��� ���ǵǾ���.
SELECT *
FROM dual;

--���ڿ��� ��ҹ��� : LOWER, UPPER, INITCAP -> �߻������ �ʴ´�. �ڹٿ��� �̷��� ���ڿ��� ó���� �����ϱ� ����
--FROM�� emp�� ������ emp�� �ุŭ ��µȴ�. �ֳ��ϸ� ����� �Լ��̱� �����̴�. WHERE���� ������ ������ ������ �����ϴ� �ุŭ ���
SELECT LOWER('Hello, World!') , UPPER('Hello, World!'), INITCAP('hello, World!')
FROM dual;

--�Լ��� WHERE �������� ����� �����ϴ�.
--��� �̸��� SMITH�� ����� ��ȸ

--SQL�ۼ��� �Ʒ� ���´� ���� �ؾ��Ѵ�.
--���̺��� �÷��� �������� �ʴ� ���·� SQL�� �ۼ��Ѵ�.
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

SELECT CONCAT('Hello', ', World!') CONCAT,
        SUBSTR('Hello, World',1,5)  SUBSTR, --1~5
        LENGTH('Hello, World') len,
        INSTR('Hello, World','o') ins,
        INSTR('Hello, World','o',6) ins2,
        LPAD('Hello, World',15, '*') lpad,
        RPAD('Hello, World',15, '*') rpad,
        REPLACE('Hello, World', 'Hello', 'SAMSUNG') replace,
        TRIM('   Hello, Wolrd   ') trim ,--������
        TRIM('d' FROM 'Hello, Wolrd') trim1 --������ �ƴ� �ҹ��� d�� �����Ѵ�.
FROM dual;

-- ���� �Լ�
-- ROUND : �ݿø�(10.6�� �Ҽ��� ù��° �ڸ����� �ݿø� -> 11),
-- TRUNC : ����(����) (10.6�� �Ҽ��� ù��° �ڸ����� ���� --> 10)
-- MOD : ������ (���� �ƴ϶� ������ ������ �� ������ ��) (13/5 -> ��:2 ������ : 3)
-- ROUND, TRUNC : ����� �ڸ����� �ݿø�/����


--ROUND
SELECT ROUND(105.54, 1) round, --�ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� �ݿø��Ѵ�.
        ROUND(105.55, 1) round,
        ROUND(105.54, 0) round, -- �ݿø� ����� �����κи�, --> �Ҽ��� ù��° �ڸ����� �ݿø��Ѵ�.
        ROUND(105.54, -1) round, -- �ݿø� ����� ���� �ڸ����� --> ���� �ڸ����� �ݿø��Ѵ�.
        ROUND(105.55) -- �ι�° ���ڸ� �Է����� ���� ��� 0�� �����Ѵ�. �� �⺻���� 0�̴�.
FROM DUAL;

--TRUNC
SELECT TRUNC(105.54,1) trunc,-- ������ ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� ����
    TRUNC(105.555,2) trunc, -- ������ ����� ������ �ι�° �ڸ����� �������� --> ����° �ڸ����� ����
    TRUNC(105.55, 0) trunc, -- ������ �ܷΰ��� ������(���� �ڸ�)���� �������� --> �Ҽ��� ù���� �ڸ����� ����
    TRUNC(105.55, -1) trunc, -- ������ ����� 10���ڸ����� �������� --> ���� �ڸ����� ����
    TRUNC(105.55) --�ι��� ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

--emp ���̺��� ����� �޿�(sal)�� 1000���� �������� ��

SELECT TRUNC(sal/1000), -- ���� ���غ�����
        MOD(sal,1000) --mod�� ����� divisor���� �׻� �۴�.
FROM emp;

DESC emp;

--�⵵2�ڸ�/��2�ڸ�/����2�ڸ� --> ǥ���Ǵ� ���°� ���� �������̴�.
SELECT ename, hiredate
FROM emp;

--SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ��¥ ������ �����ϴ� Ư�� �Լ�
-- �Լ���(����1, ����2)
-- date + ���� = ���� ����
-- 1 = �Ϸ�
-- 1�ð� = 1/24
-- 2020/01/28 + 5 -> 02/02

-- ���� ǥ�� : ����
-- ���� ǥ�� : �̱� �����̼� + �̱� �����̼� --> '���ڿ�'
-- ��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ����') --> TO_DATE('2020/01/28', 'YYYY/MM/DD')
SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;

--fn1
SELECT TO_DATE('2019/12/31','YYYY/MM/DD') LASTDAY, TO_DATE('2019/12/31','YYYY/MM/DD')-5 AS LASTDAYE_BEFORE, 
       SYSDATE now, SYSDATE -3 NOW_BEFORE
FROM dual;






