--超电雷光虫
function c11112048.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11112048)
	e1:SetTarget(c11112048.target)
	e1:SetOperation(c11112048.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112048,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,111120480)
	e2:SetCondition(c11112048.spcon)
	e2:SetCost(c11112048.spcost)
	e2:SetTarget(c11112048.sptg)
	e2:SetOperation(c11112048.activate2)
	c:RegisterEffect(e2)
end
function c11112048.filter(c)
	return c:IsFaceup() and c:IsCode(11112029) and c:IsCanAddCounter(0xfb,1)
end
function c11112048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11112048.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11112048.filter,tp,LOCATION_MZONE,0,1,nil) 
	    and Duel.IsPlayerCanDiscardDeck(tp,2)end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11111048,0))
	Duel.SelectTarget(tp,c11112048.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end	
function c11112048.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
	    Duel.DiscardDeck(tp,2,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsSetCard,nil,0x15b)
		if ct>0 then
		    if tc:GetCounter(0xfb)==9 then
		        tc:AddCounter(0xfb,1)
			else
                tc:AddCounter(0xfb,ct)		
			end	
		end
	end	
end
function c11112048.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c11112048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11112048.spfilter(c,e,tp)
	return c:IsCode(11112011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11112048.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11112048.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11112048.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11112048.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c11112048.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
end