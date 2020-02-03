commit;

select *
from customer;

select *
from cycle;

--판매점 : 200~250
-- 고객당  2.5개 제품
-- 하루 : 500~750
-- 한달 : 15000~17500

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

--SYSTEM 계정을 통한 hr 계정 활성화
--해당 오라클 서버에 등록된 사용자(계정) 조회
SELECT *
FROM dba_users;

--HR 계정의 비밀번호를 JAVA로 초기화
ALTER USER HR IDENTIFIED BY java;
ALTER USER HR ACCOUNT UNLOCK;

--OUTER JOIN
--두 테이블을 조인할 때 연결 조건을 만족 시키지 못하는 데이터를 기준으로
--지정한 테이블의 데이터만이라도 조회 되게끔하는 조인방식

--연결조건 : e.mgr = m.empno : KING의 MGR NULL이기 때문에 조인에 실패한다.
--EMP 테이블의 데이터는 총 14건이지만 아래와 같은 쿼리에서는 결과가 13건이 된다.(1건이 조인실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;


--ANSI OUTER
-- 1. 조인에 실패하더라도 조회가 될 테이블을 선정(매니저 정보가 없어도 사원정보는 나오게끔)

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr=m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr=m.empno);

--ORACLE OUTER JOIN
--데이터가 없는 쪽에 테이블 컬럼뒤에 (+)기호를 붙여준다.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--위의 SQL을 안시 SQL으로 변경해보세요
--매니저의 부서번호가 10번인 사람만 조회

SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno AND m.deptno = 10);

--아래 LEFT OUTER 조인은 실질적으로 OUTER조인이 아니다.
--아래 INNER JOIN과 결과가 동일하다.
--FROM에서 outerjoin을 돌리고 where 절에서 일반적으로 조건식을 수행하기 때문에 inner조인과 같은 결과가 나타난다.
SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno)
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e JOIN emp m ON (e.mgr=m.empno)
WHERE m.deptno = 10;

-- 오라클 OUTER JOIN
-- 오라클 OUTER JOIN시 기준 테이블의 반대편 테이블의 모든컬럼에 (+)를 붙여야
-- 정상적인 OUTER JOIN으로 동작한다.
-- 한컬럼이라도 (+)를 누락하면 INNER JOIN으로 동작
SELECT e.empno, e.ename, e.mgr, m.ename , m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+) =10;

-- 사원 - 매니저간 RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT e.empno, e.ename, e.mgr, m.empno , m.ename
FROM emp e , emp m
WHERE e.mgr(+)=m.empno;

SELECT e.empno, e.ename, e.mgr, m.empno , m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);


--FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복제거;
--오라클 outer join에서는 full outer  문법을 지원하지 않는다.
--LEFT OUTER : 14건 + RIGHT OUTER 
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
               
