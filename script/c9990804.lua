--十人雇佣兵
function c9990804.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9990804.cost)
	e1:SetTarget(c9990804.target)
	e1:SetOperation(c9990804.activate)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9990804.condition2)
	e2:SetCost(c9990804.cost2)
	e2:SetTarget(c9990804.target2)
	e2:SetOperation(c9990804.operation2)
	c:RegisterEffect(e2)
end
function c9990804.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9990804.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,9990804,0,0x1011,2000,1200,4,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9990804.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,9990804,0,0x1011,2000,1200,4,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
	c:AddTrapMonsterAttribute(0x1010,ATTRIBUTE_EARTH,RACE_WARRIOR,4,2000,1200)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) c:TrapMonsterBlock()
end
function c9990804.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c9990804.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9990804.filter(c)
	return c:IsCode(9990804) and c:IsSSetable(true)
end
function c9990804.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)~=0
		and Duel.IsExistingMatchingCard(c9990804.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9990804.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9990804.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
