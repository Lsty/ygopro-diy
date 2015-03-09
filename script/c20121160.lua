--小鸟游★优美
function c20121160.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20121160.cost)
	e1:SetTarget(c20121160.target)
	e1:SetOperation(c20121160.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c20121160.thtg)
	e2:SetOperation(c20121160.thop)
	c:RegisterEffect(e2)
end
function c20121160.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20121160)==0 and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.RegisterFlagEffect(tp,20121160,RESET_PHASE+PHASE_END,0,1)
end
function c20121160.filter1(c,e,tp)
	return c:GetCode()==20121114 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20121160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20121160.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20121160.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(c20121160.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then
		local t1=g:GetFirst()
		Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c20121160.filter(c)
	return c:GetCode()==20121114 and c:IsAbleToHand() and c:IsFaceup()
end
function c20121160.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c20121160.filter(chkc) end
	if chk==0 then return Duel.GetFlagEffect(tp,20121160)==0 and Duel.IsExistingTarget(c20121160.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c20121160.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.RegisterFlagEffect(tp,20121160,RESET_PHASE+PHASE_END,0,1)
end
function c20121160.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end