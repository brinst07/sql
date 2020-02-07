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
--�ߺ��� �����Ҽ� �ִ�. DISTINCT -> �׷��� �߿������� �ʴ�.
SELECT DISTINCT deptno
FROM emp;


SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM product p
WHERE p.pid NOT IN(SELECT c.pid
                        FROM cycle c
                        WHERE c.cid =1);
                        
--sub6
SELECT pid
FROM cycle
WHERE cid = 1;

select *
FROM product
WHERE pid = 1 AND pid in (SELECT pid
                          FROM cycle
                          WHERE cid = 2);
                          
select *
from cycle;

select *
from product;

SELECT *
FROM cycle c
WHERE c.cid =1 AND c.pid in(SELECT pid
                            FROM cycle
                            WHERE cid=2);
                            

--sub6                            
SELECT *
FROM cycle c , customer cu, product p
WHERE c.cid=1 AND c.pid in(SELECT pid
                            FROM cycle
                            WHERE cid=2)
AND c.pid =p.pid AND c.cid = cu.cid;

--��Į�� ���������� �����ϴ� ������ ���� �ʰ�... -> ���� ����� �ƴϴ�.
SELECT cycle.cid, (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);
            
--�Ŵ����� �����ϴ� ������ ��ȸ(king�� ������ 13���� �����Ͱ� ��ȸ
SELECT ename
FROM emp
WHERE mgr is not null;
    
--EXSITS ���ǿ� �����ϴ� ���� �����ϴ��� ���ϴ��� Ȯ���ϴ� ������
--�ٸ� �����ڿ� �ٸ��� WHERE���� �÷��� ������� �ʴ´�.
-- WHERE empno = 7369
-- WHERE EXISTS (SELECT 'X'
--               FROM ....);
-- ���� �߿��Ѱ� �ƴ϶� �����ϴ��� ���ΰ� �߿��ϱ� ������ 'x' �� ��� -> �����

--�Ŵ����� �����ϴ� ������ EIXSTS �����ڸ� ���� ��ȸ

SELECT e.empno, e.ename, e.mgr
FROM emp e
WHERE EXISTS (SELECT 'x'
              FROM emp m
              WHERE e.mgr=m.empno);
              
--sub9
SELECT pid, pnm
FROM product p
WHERE EXISTS (SELECT 'x'
              FROM cycle c
              WHERE cid=1 and p.pid=c.pid);

--sub10
--�� !�� �ȵǴ��� �ٽ��ѹ� �����ϱ�
SELECT pid, pnm
FROM product p
WHERE NOT EXISTS (SELECT 'x'
              FROM cycle c
              WHERE cid = 1 and p.pid=c.pid);
              
--���տ���
--������ : UNION - �ߺ�����(���հ���) / UNION ALL - �ߺ��� �������� ����(�ӵ����)
--������ : INTERSECT(���հ���)
--������ : MINUS (���հ���)
--���տ��� �������
--�� ������ �÷��� ����, Ÿ���� ��ġ�ؾ��Ѵ�.

-- UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--UNION ALL �����ڴ� UNION �����ڿ� �ٸ��� �ߺ��� ����Ѵ�.

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);


--INTERECT (������) : ��, �Ʒ� ���տ��� ���� ���� �ุ ��ȸ


SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698,7369);

--MINUS(������) : �� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����


SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--������ ��� ������ ������ ���� ���տ�����
-- A UNION B =    B UNION A -> ����
-- A UNION ALL B  B UNION ALL A -> (���հ��信��)����
-- A INTERSECT B  B INTERSECT A -> ����
-- A MINUS B      B MINUS A -> �ٸ�

--���տ����� ��� �÷� �̸��� ó�� ������� ����� �״�� ������
SELECT 'X'as first,'B' as sec
FROM dual

UNION

SELECT 'Y','A',
FROM dual;

--����(order by)�� ���տ��� ���� ������ ���� ������ ���
SELECT deptno, dname, loc
FROM(SELECT deptno, dname, loc
     FROM dept 
     WHERE deptno IN  (10,20)
     ORDER BY DEPTNO) --> �ζ��κ�ȿ���  ORDERBY�� ����ϸ� �����ϴ�.
--ORDER BY DEPTNO --> �����߻�

UNION

SELECT *
FROM dept 
WHERE deptno IN (30,40)
ORDER BY deptno;

SELECT *
FROM fastfood;

--�õ�, �ñ���, ��������
SELECT up.sido,up.sigungu,ROUND(bmk/b,2) c , dense_rank() over(order by ROUND(bmk/b,2) desc) rank
FROM(
     SELECT  sido, sigungu,sum(a) bmk
     FROM
     
        (SELECT sido, sigungu,gb,count(gb) a
         FROM fastfood
         WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
         GROUP BY sido, sigungu,gb) 
         
     GROUP BY sido, sigungu) up 
     
    JOIN
    
    (SELECT sido, sigungu,gb,count(gb) b
     FROM fastfood
     WHERE gb IN ('�Ե�����')
     GROUP BY sido, sigungu,gb )down
     
    ON(up.sido=down.sido and up.sigungu = down.sigungu)
ORDER BY c DESC;
