--CROSS JOIN  ==> īƼ�� ���δ�Ʈ(Cartesian product)
--�����ϴ� �� ���̺��� ���� ������ �����Ǵ� ���
--������ ��� ���տ� ���� ����(����)�� �õ�
--dept(4��), emp(14)�� CROSS JOIN�� ����� 4*14 = 56��
--dept ���̺�� emp���̺��� ������ �ϱ� ���� FROM ���� �ΰ��� ���̺��� ���
--WHERE ���� �� ���̺��� ���� ������ ����
--���̺� �����ϴ� ��캸�� ������ ������ ���� ����Ѵ�.

SELECT *
FROM emp;

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno=10
AND dept.deptno = emp.deptno;

--crossjoin1
SELECT *
FROM customer CROSS JOIN product
order by customer.CID;

--SUBQUERY : �����ȿ� �ٸ� ������ �� �ִ� ���
--SUBQUERY�� ���� ��ġ�� ���� 3���� �з�
--SELECT �� : SCALAR SUBQUERY : �ϳ��� �� , �ϳ��� �÷��� �����ؾ� ������ �߻����� ����
--FROM �� : INLINE-VIEW (VIEW)  
--WHERE �� : SUBQUERY

--SMITH�� ���� �μ��� ���ϴ� �������� ������ ��ȸ
--1.SMITH�� ���ϴ� �μ� ��ȣ�� ���Ѵ�.
--2. 1������ ���� �μ� ��ȣ�� ���ϴ� ������ ������ ��ȸ�Ѵ�.

--1
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--2
SELECT *
FROM emp
WHERE deptno = 20;


--SUBQUERY�� �̿��ϸ� �ΰ��� ������ ���ÿ� �ϳ��� SQL�� ���డ��
--��ȣ���� ������ ���� ����ǰ� ������ ������ ����ȴ�.
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
               FROM emp
               WHERE ename = 'SMITH');

select *
from emp;

--�������� �ǽ�1
--sub1 : ��� �޿����� ���� �޿��� �޴� ������ ��
--1. ��ձ޿� ���ϱ�
--2. ���� ��� �޿����� ���� �޿��� �޴� ���
SELECT count(*) 
FROM emp
WHERE sal>(SELECT avg(sal)
           FROM emp);
           

--sub2
SELECT * 
FROM emp
WHERE sal>(SELECT avg(sal)
           FROM emp);
    

--������ ������
--IN : ���������� �������� ��ġ�ϴ� ���� ������ ��
--ANY [Ȱ�뵵�� �ټ� ������] : ���������� �������� �� ���̶� ������ �����Ҷ�
--ALL [Ȱ�뵵�� �ټ� ������] : ���������� �������� ��� �࿡ ���� ������ ������ ��

--SMITH�� ���ϴ� �μ��� ��� ������ ��ȸ
--SMITH�� WARD ������ ���ϴ� �μ��� ��� ������ ��ȸ


--���������� ����� ���� ���� ���� '=' �����ڸ� ������� ���Ѵ�
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));


--SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿� 2���� �ƹ��ų�)

SELECT *
FROM emp
WHERE sal < ANY (SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));

--SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿� 2���� ��ο� ���� ������)

SELECT * 
FROM emp
WHERE sal> ALL (SELECT sal
               FROM emp
               WHERE ename IN ('SMITH','WARD'));
               

--IN, NOT IN�� NULL�� ���õ� ���� ����
--������ ������ ����� 7566�̰ų� NULL
--IN �����ڴ� OR�����ڷ� ġȯ ����
--IN������ null�� �νĵ��� �ʴ´�.
--IN, NOT IN ������ ���� ���������� ����� NULL�� �����Ұ��
--��ü�� NULL�� ��ó�� �����Ѵ�.
SELECT *
FROM emp
WHERE mgr IN (7902,null);

--null�񱳴� = �����ڰ� �ƴ϶� IS NULL�� ���ؾ�����, IN�����ڴ� =�� ����Ѵ�.
SELECT *
FROM emp
WHERE mgr =7902
OR mgr is null;

--empno NOT IN (7902, NULL) --> AND
--�����ȣ�� 7902�� �ƴϸ鼭(AND) NULL�� �ƴ� ������

SELECT *
FROM emp
WHERE empno NOT IN(7902, NULL);

SELECT *
FROM emp
WHERE empno != 7902 AND
      empno != null;
      
      
SELECT *
FROM emp
WHERE empno != 7902 AND
      empno is not null;
      
--pairwisw (������)
--(mgr,deptno)
--(7698,30), (7839,10)


SELECT *
FROM emp
WHERE( mgr, deptno) IN(SELECT mgr, deptno
                       FROM emp
                       WHERE empno IN(7499,7782));

--non-pairwise �� �������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
--mgr ���� 7698 �̰ų� 7839 �̸鼭
--deptno�� 10�̰ų� 30���� ����
--MGR,detpno
--(7698,10) , (7698,30)
--(7839,10), (7839,30)

SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
             FROM emp
             WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno
              FROM emp
              WHERE empno IN(7499,7782));
              

--��Į�� �������� SELECT ���� ��� , 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
--��Į�� ���������� MAIN������ �÷��� ����ϴ°� �����ϴ�.


SELECT (SELECT SYSDATE
        FROM dual), d.*
FROM dept d;

SELECT empno, ename, deptno, 
    (SELECT dname
     FROM dept
     WHERE emp.deptno = dept.deptno) dname
FROM emp;


--INLINE VIEW : FROM���� ����Ǵ� ��������

--MAIN������ �÷��� SUBQUERY���� ����ϴ� �� ������ �����з�
--����� ��� : correlateed subquery(��ȣ ���� ����), ���������� �ܵ����� ���� �ϴ°� �Ұ����ϴ�.
        --      ���� ������ ������ �ִ�.(main --> sub)
--������� ���� ��� : non-correlated subquery(���ȣ ���� ��������), ���������� �ܵ����� �����ϴ°� ����
    --              ���� ������ ������ ���� �ʴ�.(main --> sub) (sub --> main)

--��������� �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp
WHERE sal>
        (SELECT AVG(sal)
        FROM emp);
        
--������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ        

SELECT *
FROM emp e
WHERE sal>
        (SELECT AVG(sal)
         FROM emp e1
         WHERE e.deptno = e1.deptno
         );

--���� ������ ������ �̿��ؼ� Ǯ���
--1. ���� ���̺� ����
--   emp, �μ��� �޿� ���

SELECT e.ename, sal.*
FROM emp e, ( SELECT deptno, AVG(sal) avg_sal
                FROM emp GROUP BY deptno) sal
WHERE e.deptno = sal.deptno
AND e.sal> sal.avg_sal;


SELECT *
FROM emp e, (SELECT deptno, AVG(sal) avg_sal
             FROM emp
             GROUP BY deptno)sal
WHERE e.deptno = sal.deptno
AND e.sal>sal.avg_sal;

--sub4 ������ �߰�
INSERT INTO dept VALUES(99,'ddit','daejeon');
commit;
DELETE dept
WHERE deptno = 99;


-- Ʈ����� Ȯ�� : commit
-- Ʈ����� ��� : rollback

--sub4
--dept ���̺��� 5���� �����Ͱ� ����
--emp ���̺��� 14���� ������ �ְ�, ������ �ϳ��� �μ��� �����ִ�(deptno)
--�μ��� ������ ���� ���� ���� �μ� ������ ��ȸ
--������������ �������� ������ �´��� Ȯ���� ������ �ϴ� �������� �ۼ�

SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);
--WHERE (SELECT deptno FROM emp) NOT IN deptno;
-- in ���ʿ� �ִ� ���� ��� ���� �ϳ����� �Ѵ�. ������ 14���� ������ �������̱� ������ �ȵȴ�.
-- sql���� ��ü�� ���������� �� �ϳ��ϳ��� ���Խ�Ű�� ������� �����غ��� ex) for��
-- �׷���̸� ����ϸ� �����͸� �а� ���� �۾��� �߰��Ǳ� ������ �ӵ��鿡���� ������.
