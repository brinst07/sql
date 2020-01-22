--1
SELECT *
FROM LPROD;

--2
SELECT BUYER_ID, BUYER_NAME
FROM BUYER;

--3
SELECT*
FROM CART;

--4
SELECT MEM_ID, MEM_PASS, MEM_NAME
FROM member;

SELECT mem_id, mem_pass, mem_name
from member;

SELECT *
FROM users;

--���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
-- 1. SELECT * -> �� �˻��ؼ� Ȯ���ϱ�
-- 2. TOOL�� ��� (�����-TABLES)
-- 3. DESC ���̺�� (DESC-DESCRIBE)

DESC users;

SELECT userid as u_id,usernm, reg_dt+5 reg_dt_after_5day
FROM users;

--��¥ ���� (reg_dt �÷��� date ������ ���� �� �ִ� Ÿ��)
--SQL ��¥ �÷� + (���ϱ� ����)
--�������� ��Ģ������ �ƴѰ͵�(5+5)
--String h = "hello";
--String w = "world";
--String hw = h+w; --�ڹٿ����� �� ���ڿ��� ����
--SQL���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���Ѵ�.
--reg_dt : �����¥ �÷�
--null : ���� �𸣴� ����
--null�� ���� ���� ����� �׻� null

SELECT prod_id as id , prod_name as name
FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

SELECT buyer_id ���̾���̵� , buyer_name �̸�
FROM buyer;

--���ڿ� ����
--�ڹ� ���� ���ڿ� ���� : +
--SQL������ : || ('Hello' || 'world')
--SQL������ : concat('Hello','world')

SELECT userid || usernm AS id_name
FROM users;

SELECT CONCAT(userid,usernm) AS id_name
FROM users;

--SQL������ ������ ����.(�÷��� ����� ����, pl/sql���� ���� ������ ����)
--SQL���� ���ڿ� ����� �̱� �����̼����� ǥ��
-- "Hello, World" --> 'Hello, world'

--���ڿ� ����� �÷����� ����
--user id : brown
--user id : cony
--��Ī���� ������ �� �� ����.
SELECT 'user id : '|| userid AS "Use rid "
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';'AS QUERY 
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT * FROM ' , table_name),';') AS QUERY
FROM user_tables;
--CONCAT(arg1, arg2)

--�ڹٿ����� =�� �Ҵ� ���Կ������̴�
--if(a ==5) a�� ���� 5���� ��
--sql���� =�� equal�� �����̴�. sql������ ������ ������ ������ pl/sql�� �����Ѵ�.

--users�� ���̺��� ��� �࿡ ���ؼ� ��ȸ
--users���� 5���� �����Ͱ� ����
SELECT *
FROM users;

--WHERE �� : ���̺��� �����͸� ��ȸ�� �� ���ǿ� �´� ROW(��)�� ��ȸ
--ex : userid �÷��� ���� brown�� �ุ ��ȸ
-- brown�� 'brown'�� �������� �˾ƾ��Ѵ�.
-- brown�� �÷�, 'brown'�� ���ڿ� ����� �ν��Ѵ�.
SELECT *
FROM users
WHERE userid = 'brown';

SELECT *
FROM users
WHERE userid <> 'brown';

SELECT *
FROM users
WHERE userid != 'brown';


DESC emp;

SELECT *
FROM emp;

SELECT *
FROM emp
WHERE ename = 'JONES';

SELECT *
FROM emp
WHERE COMM is not null;

desc emp; --employee

--5 > 10 FALSE
--5>5 FALSE
--5>=5 TRUE
-- emp ���̺��� deptno(�μ���ȣ)�� 30���� ũ�ų� ���� ����鸸

SELECT *
FROM emp
WHERE deptno>= 30;
-- ���ڴ� '�� ������ �ʾƵ� �ȴ�.

-- ���ڿ� : '���ڿ�
-- ���� : 50
-- ��¥ : ??? --> �Լ��� ���ڿ��� �����ؼ� ǥ���Ѵ�. ���ڿ��� �̿��Ͽ� ǥ������������ ���������ʴ´�. 
-- �ֳ��ϸ� �������� ��¥ ǥ�� ����� �ٸ��� �����̴�.
-- �ѱ� : �⵵4�ڸ� -�� 2����-����2�ڸ� ������ �ٸ������ �ٸ��� ǥ���ϴ� ������� ����.
-- �Ի����ڰ� 1980�� 12�� 17�� ������ ��ȸ

SELECT *
FROM emp
WHERE hiredate = '80/12/17';

--TO_DATE : ���ڿ��� date Ÿ������ �����ϴ� �Լ�
--TO_DATE (��¥���� ���ڿ�, ù��° ������ ����)

SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217', 'YYYYMMDD');

--�������� and, or ������
SELECT *
FROM emp
WHERE sal>=1000 AND sal<=2000 AND deptno = 30;

--���������ڸ� �ε�ȣ ��ſ� BETWEEN AND �����ڷ� ��ü
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal in(1300,5000);

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101','YYYYMMDD'); 