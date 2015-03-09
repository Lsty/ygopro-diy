--想象中的朋友 古明地恋
function c93300014.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c93300014.cost)
	e1:SetTarget(c93300014.target)
	e1:SetOperation(c93300014.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c93300014.thcon)
	e3:SetTarget(c93300014.thtg)
	e3:SetOperation(c93300014.thop)
	c:RegisterEffect(e3)
end
function c93300014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c93300014.filter1(c)
	return c:GetPosition()~=POS_FACEUP_DEFENCE
end
function c93300014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93300014.filter1,tp,0,LOCATION_MZONE,1,nil) end
end
function c93300014.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c93300014.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,true)
end
function c93300014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and ((re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_PSYCHO)) or re:GetHandler():GetCode()==93300010)
end
function c93300014.filter(c)
	return c:IsControlerCanBeChanged() and c:IsCanBeEffectTarget()
end
function c93300014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.GetFlagEffect(tp,93300014)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c93300014.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c93300014.filter,tp,0,LOCATION_MZONE,nil)
	local sg=g:RandomSelect(1-tp,1)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,sg,1,0,0)
	Duel.RegisterFlagEffect(tp,93300014,RESET_PHASE+PHASE_END,0,1)
end
function c93300014.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,PHASE_END,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end