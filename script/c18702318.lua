--操鸟术 羽爆
function c18702318.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c18702318.cost)
	e1:SetTarget(c18702318.target)
	e1:SetOperation(c18702318.activate)
	c:RegisterEffect(e1)
	--search
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(26400609,3))
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e4:SetCode(EVENT_PHASE+PHASE_END)
	--e4:SetRange(LOCATION_SZONE)
	--e4:SetCountLimit(1)
	--e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_REPEAT)
	--e4:SetCondition(c18702318.con)
	--e4:SetCost(c18702318.acost)
	--e4:SetTarget(c18702318.thtg)
	--e4:SetOperation(c18702318.thop)
	--c:RegisterEffect(e4)
end
function c18702318.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c18702318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c18702318.costfilter(c,e,dg)
	if not c:IsSetCard(0x257) and c:IsType(TYPE_MONSTER) then return false end
	local a=0
	if dg:IsContains(c) then a=1 end
	if c:GetEquipCount()==0 then return dg:GetCount()-a>=2 end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>=2
end
function c18702318.tgfilter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c18702318.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetReleaseGroup(tp)
			local dg=Duel.GetMatchingGroup(c18702318.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
			local res=rg:IsExists(c18702318.costfilter,1,e:GetHandler(),e,dg)
			return res
		else
			return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetReleaseGroup(tp)
		local dg=Duel.GetMatchingGroup(c18702318.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c18702318.costfilter,1,1,e:GetHandler(),e,dg)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18702318.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c18702318.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c18702318.ffilter(c)
	return c:IsSetCard(0x257) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(18702318)
end
function c18702318.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c18702318.filter(ffilter) end
	if chk==0 then return  Duel.IsExistingTarget(c18702318.ffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SelectTarget(tp,c18702318.ffilter,tp,LOCATION_DECK,0,1,1,nil)
end
function c18702318.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end