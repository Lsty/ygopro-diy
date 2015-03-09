--斩首循环-蓝色学者与戏言跟班
function c24600015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCost(c24600015.cost)
	e1:SetOperation(c24600015.activate)
	c:RegisterEffect(e1)
	if c24600015.counter==nil then
		c24600015.counter=true
		c24600015[0]=0
		c24600015[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c24600015.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetCondition(c24600015.regcon)
		e3:SetOperation(c24600015.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_CHAIN_NEGATED)
		e4:SetCondition(c24600015.regcon)
		e4:SetOperation(c24600015.addcount1)
		Duel.RegisterEffect(e4,0)
	end
end
function c24600015.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c24600015[0]=0
	c24600015[1]=0
end
function c24600015.regcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:GetHandler():IsSetCard(0x246) and loc==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)
end
function c24600015.addcount(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local p=c:GetControler()
	c24600015[p]=c24600015[p]+1
end
function c24600015.addcount1(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local p=c:GetControler()
	if c24600015[p]==0 then c24600015[p]=1 end
	c24600015[p]=c24600015[p]-1
end
function c24600015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,24600015)==0 end
	Duel.RegisterFlagEffect(tp,24600015,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c24600015.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c24600015.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c24600015.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,24600015)
	Duel.Draw(tp,c24600015[tp],REASON_EFFECT)
end
