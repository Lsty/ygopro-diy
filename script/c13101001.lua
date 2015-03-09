--伊捷符镇兵
function c13101001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c13101001.target1)
	e1:SetOperation(c13101001.activate)
	c:RegisterEffect(e1)
	--Releaced
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13101001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c13101001.condition2)
	e2:SetTarget(c13101001.target2)
	e2:SetOperation(c13101001.operation2)
	c:RegisterEffect(e2)
end
function c13101001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13101001,0,0x21,2000,1000,6,RACE_PSYCHO,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13101001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,13101001,0,0x21,2000,1000,6,RACE_PSYCHO,ATTRIBUTE_WATER) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_WATER,RACE_PSYCHO,6,2000,1000)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
end
function c13101001.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c13101001.filter(c)
	return c:IsSetCard(0xeef) and c:GetCode()~=13101001 and c:IsAbleToHand()
end
function c13101001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13101001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13101001.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13101001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g) end
end
