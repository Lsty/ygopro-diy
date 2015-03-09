--天界之星 比那名居天子
function c6668608.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x740),6,2)
	c:EnableReviveLimit()
	--ret&draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,6668608)
	e1:SetCost(c6668608.cost)
	e1:SetTarget(c6668608.target1)
	e1:SetOperation(c6668608.operation1)
	c:RegisterEffect(e1)
	--ind
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e99:SetCondition(c6668608.indcon)
	e99:SetValue(1)
	c:RegisterEffect(e99)
end
function c6668608.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end	
function c6668608.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c6668608.filter1(c)
	return c:IsSetCard(0x741) or c:IsSetCard(0x742) and c:IsAbleToHand()
end
function c6668608.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6668608.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6668608.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c6668608.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c6668608.filter(c,e,tp)
	return c:IsSetCard(0x740) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c6668608.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c6668608.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	Duel.BreakEffect()
	local s1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
	local s2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(6668608,0),aux.Stringid(6668608,1))
	elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(6668608,0))
	elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(6668608,1))+1
	else return end
	if op==0 then 	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6668608.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP) 
	else Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT) end
end
end