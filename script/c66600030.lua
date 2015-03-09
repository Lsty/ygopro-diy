--魔姬的鸟居
function c66600030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c66600030.ccost)
	e1:SetTarget(c66600030.target1)
	e1:SetOperation(c66600030.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c66600030.condition)
	e2:SetCost(c66600030.cost)
	e2:SetTarget(c66600030.target2)
	e2:SetOperation(c66600030.operation)
	c:RegisterEffect(e2)
end
function c66600030.targetfilter(c,e)
	return c:IsDestructable() and c:IsFaceup() and c:IsSetCard(0x666) and c:IsCanBeEffectTarget(e)
end
function c66600030.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c66600030.targetfilter,tp,LOCATION_MZONE,0,1,nil,e)
end
function c66600030.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local cc=Duel.GetCurrentChain()
	if cc==1 then return false end
	local te=Duel.GetChainInfo(cc-1,CHAININFO_TRIGGERING_EFFECT)
	if not c66600030.condition(e,tp,eg,ep,ev,te,r,rp) then return false end
	if Duel.GetFlagEffect(tp,66600030)==0
		and Duel.SelectYesNo(tp,aux.Stringid(66600030,1)) then
		e:SetLabel(1)
		Duel.RegisterFlagEffect(tp,66600030,RESET_PHASE+PHASE_END,0,1)
	end
end
function c66600030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600030)==0 end
	Duel.RegisterFlagEffect(tp,66600030,RESET_PHASE+PHASE_END,0,1)
end
function c66600030.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if e:GetLabel()~=1 then return end
	local ct=Duel.GetCurrentChain()
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	Duel.SetOperationInfo(ct-1,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	c66600030[e]=te
	c66600030[te]={}
	c66600030[te][1]=Duel.SelectTarget(1-tp,c66600030.targetfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
end
function c66600030.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local ct=Duel.GetCurrentChain()
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	Duel.SetOperationInfo(ct-1,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	c66600030[e]=te
	c66600030[te]={}
	c66600030[te][1]=Duel.SelectTarget(1-tp,c66600030.targetfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
end
function c66600030.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=c66600030[e]
	if te then
		local tc=c66600030[te][1]
		if tc then
			tc:CreateEffectRelation(te)
			c66600030[te][2]=te:GetOperation()
			te:SetOperation(c66600030.operX)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_OVERLAY+LOCATION_EXTRA)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCondition(c66600030.resetcond)
			e1:SetOperation(c66600030.resetoper)
			e:GetHandler():RegisterEffect(e1)
			c66600030[e1]=te
		end
	end
end
function c66600030.resetcond(e,tp,eg,ep,ev,re,r,rp)
	return re==c66600030[e]
end
function c66600030.resetoper(e,tp,eg,ep,ev,re,r,rp)
	if re==c66600030[e] and c66600030[re][2] then
		re:SetOperation(c66600030[re][2])
		e:Reset()
	end
end
function c66600030.operX(e,tp,eg,ep,ev,re,r,rp)
	local tc=c66600030[e][1]
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end