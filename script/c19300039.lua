--幻想镜现诗·六十年目的东方裁判
function c19300039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19300039,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c19300039.cost)
	e2:SetTarget(c19300039.target)
	e2:SetOperation(c19300039.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c19300039.splimit)
	c:RegisterEffect(e4)
end
function c19300039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return e:GetHandler():GetFlagEffect(19300039)<=1
		and tc:IsSetCard(0x193) and tc:GetControler()==tp end
	e:GetHandler():RegisterFlagEffect(19300039,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c19300039.filter(c,val)
	local lv=c:GetLevel()
	return lv>=0 and lv<val and c:IsSetCard(0x193) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19300039.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c19300039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	if Duel.IsExistingMatchingCard(c19300039.filter,tp,LOCATION_DECK,0,1,nil,tc:GetLevel()) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19300039,0))
		sel=Duel.SelectOption(tp,aux.Stringid(19300039,1),aux.Stringid(19300039,2))
	else
		sel=1
	end
	e:SetLabel(sel)
	if sel==0 then
		tc:CreateEffectRelation(e)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif sel==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c19300039.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c19300039.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		local tc=eg:GetFirst()
		if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c19300039.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
		end
	elseif sel==1 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c19300039.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end