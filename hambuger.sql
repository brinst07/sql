--시도, 시군구, 버거지수
--내가 만든 햄버기 지수
SELECT up.sido,up.sigungu,ROUND(bmk/b,2) c , dense_rank() over(order by ROUND(bmk/b,2) desc) rank
FROM(
     
     
        (SELECT sido, sigungu,count(gb) bmk
         FROM fastfood
         WHERE gb IN ('버거킹','맥도날드','KFC')
         GROUP BY sido, sigungu) up

    JOIN
    
    (SELECT sido, sigungu,gb,count(gb) b
     FROM fastfood
     WHERE gb IN ('롯데리아')
     GROUP BY sido, sigungu,gb )down
     
    ON(up.sido=down.sido and up.sigungu = down.sigungu))
ORDER BY c DESC;


--선생님이 만드신 코드
--fastfood 테이블을 한번만 읽는 방식으로 작성하기
--아래와 같은 코드를 작성할때 분모가 되는 롯데리아가 0 일경우가 생긴다 이때는 스스로 처리하는게 아니라
--상급자에게 물어보고 하는것이 좋다.


SELECT sido, sigungu, ROUND((kfc+버거킹+mac)/롯데리아,2) score
FROM
        (SELECT sido, sigungu,
            NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, NVL(SUM(DECODE(gb, '버거킹', 1)),0)버거킹,
            NVL(SUM(DECODE(gb, '맥도날드', 1)),0) mac, NVL(SUM(DECODE(gb, '롯데리아', 1)),1)롯데리아
        FROM fastfood
        WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
        GROUP BY sido, sigungu)
ORDER BY score desc;

