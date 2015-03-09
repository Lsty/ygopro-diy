--镜空间
function c11111049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c11111049.descon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111049,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11111049.discon)
	e2:SetCost(c11111049.discost)
	e2:SetTarget(c11111049.distg)
	e2:SetOperation(c11111049.disop)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11111049,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c11111049.atkcon)
	e3:SetCost(c11111049.atkcost)
	e3:SetTarget(c11111049.atktg)
	e3:SetOperation(c11111049.atkop)
	c:RegisterEffect(e3)
end
function c11111049.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_SPELLCASTER+RACE_FAIRY)
end
function c11111049.descon(e)
	return not Duel.IsExistingMatchingCard(c11111049.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11111049.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetFirst():IsOnField() and tg:GetFirst():IsControler(tp) and Duel.IsChainNegatable(ev)
end	
function c11111049.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c11111049.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11111049.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c11111049.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp
end
function c11111049.rfilter(c)
	return c:IsRace(RACE_FAIRY+RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c11111049.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111049.rfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111049.rfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11111049.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) and tg:IsPosition(POS_FACEUP_ATTACK) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,2,0,0)
	local rec=tg:GetBaseAttack()/2
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c11111049.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,2)
		tc:RegisterEffect(e1)
	end
    Duel.BreakEffect()	
	Duel.Recover(tp,tc:GetBaseAttack()/2,REASON_EFFECT)
end