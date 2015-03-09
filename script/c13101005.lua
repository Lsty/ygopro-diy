--瑟雷尼亚符镇兵
function c13101005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c13101005.target1)
	e1:SetOperation(c13101005.activate)
	c:RegisterEffect(e1)
	--Releaced
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13101005,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c13101005.condition2)
	e2:SetTarget(c13101005.target2)
	e2:SetOperation(c13101005.operation2)
	c:RegisterEffect(e2)
end
function c13101005.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13101005,0,0x21,700,2300,6,RACE_BEAST,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13101005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,13101005,0,0x21,700,2300,6,RACE_BEAST,ATTRIBUTE_WIND) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_WIND,RACE_BEAST,6,700,2300)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
end
function c13101005.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c13101005.filter(c)
	return c:IsSetCard(0xeef) and c:GetCode()~=13101005 and c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function c13101005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c13101005.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c13101005.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c13101005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
