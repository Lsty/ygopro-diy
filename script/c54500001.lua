--Another·水野早苗
function c54500001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c54500001.cost)
	e1:SetTarget(c54500001.target1)
	e1:SetOperation(c54500001.operation1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c54500001.condtion)
	e2:SetTarget(c54500001.target)
	e2:SetOperation(c54500001.operation)
	c:RegisterEffect(e2)
end
function c54500001.cfilter(c)
	return c:IsSetCard(0x545) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c54500001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,54500001)==0
		and Duel.IsExistingMatchingCard(c54500001.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c54500001.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,54500001,RESET_PHASE+PHASE_END,0,1)
end
function c54500001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54500001.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c54500001.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x545)
end
function c54500001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,54500001)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
	Duel.RegisterFlagEffect(tp,54500001,RESET_PHASE+PHASE_END,0,1)
end
function c54500001.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x545) and c:IsType(TYPE_MONSTER)
end
function c54500001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local d=dg:FilterCount(c54500001.filter,nil)
	if d>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end