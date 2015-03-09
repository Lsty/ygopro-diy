--罗蕾莱之旋律
function c9991013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9991013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9991013.target)
	e1:SetOperation(c9991013.activate)
	c:RegisterEffect(e1)
end
c9991013.list={[9991001]=9991005,[9991002]=9991006,[9991003]=9991007,[9991004]=9991008,[9991006]=9991009}
function c9991013.filter1(c)
	return c:IsSetCard(0xeff) and c:IsType(TYPE_PENDULUM)
end
function c9991013.filter2(c,e,tp)
	local code=c:GetCode() local tcode=c9991013.list[code]
	return tcode and c:IsSetCard(0xeff) and Duel.IsExistingMatchingCard(c9991013.filter2ex,tp,LOCATION_EXTRA,0,1,nil,tcode,e,tp) and c:IsAbleToRemoveAsCost()
end
function c9991013.filter2ex(c,code,e,tp)
	return c:IsCode(code) and c:IsSetCard(0xeff) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsType(TYPE_SYNCHRO)
end
function c9991013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	pel=Duel.GetFieldCard(tp,LOCATION_SZONE,6) per=Duel.GetFieldCard(tp,LOCATION_SZONE,7) lab=0
	if Duel.CheckLPCost(tp,800) and not (pel and per) and Duel.IsExistingMatchingCard(c9991013.filter1,tp,0x41,0,1,nil) then ck1=1 else ck1=0 end
	if Duel.IsExistingMatchingCard(c9991013.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) then ck2=1 else ck2=0 end
	if chk==0 then return ck1+ck2~=0 end
	if ck1+ck2==2 then if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(9991013,3)) then
		sel=3 Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9991013,4)) else sel=Duel.SelectOption(tp,aux.Stringid(9991013,1),aux.Stringid(9991013,2))+1 end end
	if ck1==1 and ck2==0 then sel=Duel.SelectOption(tp,aux.Stringid(9991013,1))+1 elseif ck1==0 and ck2==1 then sel=Duel.SelectOption(tp,aux.Stringid(9991013,2))+2 end
	if sel~=2 then Duel.PayLPCost(tp,800) lab=lab+90000000 end
	if sel~=1 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) rc=Duel.SelectMatchingCard(tp,c9991013.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
		lab=lab+rc:GetCode() Duel.Remove(rc,POS_FACEUP,REASON_COST) e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) end
	e:SetLabel(lab)
end
function c9991013.activate(e,tp,eg,ep,ev,re,r,rp)
	lab=e:GetLabel() ef1=0 ef2=0 if lab>=90000000 then ef1=1 lab=lab-90000000 end if lab~=0 then ef2=1 end if ef1+ef2==0 then return end
	pel=Duel.GetFieldCard(tp,LOCATION_SZONE,6) per=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if ef1==1 and not (pel and per) and Duel.IsExistingMatchingCard(c9991013.filter1,tp,0x41,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9991013,0))
		local tc=Duel.SelectMatchingCard(tp,c9991013.filter1,tp,0x41,0,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if ef2==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991013.filter2ex,tp,LOCATION_EXTRA,0,1,nil,c9991013.list[lab],e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c9991013.filter2ex,tp,LOCATION_EXTRA,0,1,1,nil,c9991013.list[lab],e,tp):GetFirst()
		Duel.SpecialSummon(tg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) tg:CompleteProcedure()
	end
end
