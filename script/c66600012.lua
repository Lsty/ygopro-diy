--刻时之魔姬
function c66600012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c66600012.xyzfilter,4,3)
	c:EnableReviveLimit()
	--DIRECT ATTACK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c66600012.cost)
	e1:SetCondition(c66600012.con)
	e1:SetTarget(c66600012.rmtg)
	e1:SetOperation(c66600012.rmop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetCost(c66600012.ccost)
	e2:SetTarget(c66600012.destg)
	e2:SetOperation(c66600012.desop)
	c:RegisterEffect(e2)
end
function c66600012.xyzfilter(c)
	return c:IsSetCard(0x666) or c:IsRace(RACE_PSYCHO)
end
function c66600012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600012)==0 end
	Duel.RegisterFlagEffect(tp,66600012,RESET_PHASE+PHASE_END,0,1)
end
function c66600012.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c66600012.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c66600012.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mcount=0
	if c:IsFaceup() then mcount=c:GetOverlayCount() end
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		if not og:IsContains(c) then mcount=0 end
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(66600012,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetLabel(mcount)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c66600012.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c66600012.retfilter(c)
	return c:GetFlagEffect(66600012)~=0
end
function c66600012.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c66600012.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		if Duel.ReturnToField(tc) and tc==e:GetOwner() and tc:IsFaceup() and e:GetLabel()~=0 then
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(e:GetLabel()*500)
			e:GetOwner():RegisterEffect(e1)
		end
		tc=sg:GetNext()
	end
end
function c66600012.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
		and Duel.GetFlagEffect(tp,166600012)==0 end
	Duel.RegisterFlagEffect(tp,166600012,RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600012.filter(c)
	return c:IsSetCard(0x666) and c:IsAbleToHand() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c66600012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c66600012.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c66600012.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)	
end
function c66600012.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	while tc do
		if tc:GetControler()==e:GetOwner() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.Remove(tc,0,REASON_EFFECT)
		end
		tc=tg:GetNext()
	end
end