commit;

select *
from customer;

select *
from cycle;

--�Ǹ��� : 200~250
-- ����  2.5�� ��ǰ
-- �Ϸ� : 500~750
-- �Ѵ� : 15000~17500

--join3
SELECT c.cid, c.cnm, y.pid, y.day, y.CNT
FROM customer c, cycle y
WHERE c.cid = y.cid;

--join4
SELECT c.cid, c.cnm, y.pid, y.day, y.CNT
FROM customer c, cycle y
WHERE c.cid = y.cid AND CNM IN('bronw','sally');


--join5
SELECT c.cid, c.cnm, y.pid,p.pnm, y.day, y.CNT
FROM customer c, cycle y, product p
WHERE c.cid = y.cid AND p.pid = y.pid
    AND cnm IN('brown','sally');
    
--join6

SELECT c.cid, c.cnm, y.pid, p.pnm, sum(y.cnt) cnt
FROM customer c, cycle y, product p
WHERE c.cid = y.cid AND p.pid = y.pid
GROUP BY c.cid, c.cnm, y.pid, p.pnm;

SELECT c.cid, c.cnm, y.pid, p.pnm, sum(y.cnt) cnt
FROM customer c JOIN cycle y ON(c.cid=y.cid)
                JOIN product p ON(p.pid=y.pid)
GROUP BY c.cid, c.cnm, y.pid, p.pnm;

--join7
SELECT c.pid, p.pnm, sum(c.cnt)
FROM cycle c, product p
WHERE c.pid = p.pid
GROUP BY c.pid, p.pnm;

--SYSTEM ������ ���� hr ���� Ȱ��ȭ
--�ش� ����Ŭ ������ ��ϵ� �����(����) ��ȸ
SELECT *
FROM dba_users;

--HR ������ ��й�ȣ�� JAVA�� �ʱ�ȭ
ALTER USER HR IDENTIFIED BY java;
ALTER USER HR ACCOUNT UNLOCK;

--OUTER JOIN
--�� ���̺��� ������ �� ���� ������ ���� ��Ű�� ���ϴ� �����͸� ��������
--������ ���̺��� �����͸��̶� ��ȸ �ǰԲ��ϴ� ���ι��

--�������� : e.mgr = m.empno : KING�� MGR NULL�̱� ������ ���ο� �����Ѵ�.
--EMP ���̺��� �����ʹ� �� 14�������� �Ʒ��� ���� ���������� ����� 13���� �ȴ�.(1���� ���ν���)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;


--ANSI OUTER
-- 1. ���ο� �����ϴ��� ��ȸ�� �� ���̺��� ����(�Ŵ��� ������ ��� ��������� �����Բ�)

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr=m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr=m.empno);

--ORACLE OUTER JOIN
--�����Ͱ� ���� �ʿ� ���̺� �÷��ڿ� (+)��ȣ�� �ٿ��ش�.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--���� SQL�� �Ƚ� SQL���� �����غ�����
--�Ŵ����� �μ���ȣ�� 10���� ����� ��ȸ

SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno AND m.deptno = 10);

--�Ʒ� LEFT OUTER ������ ���������� OUTER������ �ƴϴ�.
--�Ʒ� INNER JOIN�� ����� �����ϴ�.
--FROM���� outerjoin�� ������ where ������ �Ϲ������� ���ǽ��� �����ϱ� ������ inner���ΰ� ���� ����� ��Ÿ����.
SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno)
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e JOIN emp m ON (e.mgr=m.empno)
WHERE m.deptno = 10;

-- ����Ŭ OUTER JOIN
-- ����Ŭ OUTER JOIN�� ���� ���̺��� �ݴ��� ���̺��� ����÷��� (+)�� �ٿ���
-- �������� OUTER JOIN���� �����Ѵ�.
-- ���÷��̶� (+)�� �����ϸ� INNER JOIN���� ����
SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+) =10;

-- ��� - �Ŵ����� RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT e.empno, e.ename, e.mgr, m.empno , m.ename
FROM emp e , emp m
WHERE e.mgr(+)=m.empno;

SELECT e.empno, e.ename, e.mgr, m.empno , m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);


--FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ�����;
--����Ŭ outer join������ full outer  ������ �������� �ʴ´�.
--LEFT OUTER : 14�� + RIGHT OUTER 
SELECT e.empno, e.ename, e.mgr, m.empno , m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--outerjoin1
SELECT b.BUY_DATE, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM  buyprod b RIGHT OUTER JOIN prod p ON(p.PROD_ID = b.BUY_PROD AND b.buy_date = TO_DATE('2005/01/25','YY/MM/DD'));

--outerjoin2
SELECT NVL(b.BUY_DATE,TO_DATE('2005/01/25','YY/MM/DD')) b, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM  buyprod b RIGHT OUTER JOIN prod p ON(p.PROD_ID = b.BUY_PROD AND b.buy_date = TO_DATE('2005/01/25','YY/MM/DD'));

--outerjoin3
SELECT NVL(b.BUY_DATE,TO_DATE('2005/01/25','YY/MM/DD')) b, b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty,0)
FROM  buyprod b RIGHT OUTER JOIN prod p ON(p.PROD_ID = b.BUY_PROD AND b.buy_date = TO_DATE('2005/01/25','YY/MM/DD'));

--outerjoin4
SELECT p.pid, p.pnm, NVL(c.cid,1), NVL(c.day,0), NVL(c.cnt,0)
FROM product p LEFT OUTER JOIN cycle c ON(p.pid = c.pid AND c.cid=1);

--outerjoin5
SELECT p.pid, p.pnm, NVL(c.cid,1), NVL(cs.cnm,'brown'), NVL(c.day,0), NVL(c.cnt,0)
FROM product p LEFT OUTER JOIN cycle c ON(p.pid = c.pid AND c.cid=1)
LEFT OUTER JOIN customer cs ON (c.cid =cs.cid);
               
