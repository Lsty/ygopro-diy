--传说之枪兵 弗拉德三世
function c999988986.initial_effect(c)
	c:SetUniqueOnField(1,0,999988986)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3984),5,2)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(c999988986.tg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(c999988986.tglimit)
	c:RegisterEffect(e2)
	 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999998,5))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c999988986.descost)
	e3:SetTarget(c999988986.destg)
	e3:SetOperation(c999988986.desop)
	c:RegisterEffect(e3)
	 --recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c999988986.reccon)
	e4:SetTarget(c999988986.rectg)
	e4:SetOperation(c999988986.recop)
	c:RegisterEffect(e4)
	 --pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c999988986.reptg)
	c:RegisterEffect(e6)
end
function c999988986.tg(e,c)
	return c~=e:GetHandler()
end
function c999988986.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c999988986.desfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsDestructable()
end
function c999988986.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and  Duel.IsExistingMatchingCard(c999988986.desfilter,tp,0,LOCATION_MZONE,1,nil) and 
	e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c999988986.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c999988986.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c999988986.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c999988986.filter(c)
	return  not c:IsLocation(LOCATION_MZONE)
end
function c999988986.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c999988986.desfilter,tp,0,LOCATION_MZONE,nil)
	local d=Duel.Destroy(g,REASON_EFFECT)
	local tg=g:Filter(c999988986.filter,nil)
	local tc=tg:GetFirst()
	while tc do
	if  d~=0  then 
	local seq=tc:GetPreviousSequence()
	    seq=seq+16 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetOperation(c999988986.disop)
		Duel.RegisterEffect(e1,tp)
		tc=g:GetNext()	   
	end
end
end
function c999988986.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
function c999988986.reccon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	return ec and ep~=tp
end
function c999988986.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ev)
end
function c999988986.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c999988986.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(999997,6)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		if e:GetHandler():IsPosition(POS_FACEUP_ATTACK) then
	    Duel.BreakEffect()
        Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENCE)
		end
		return true
	else return false end
	

end