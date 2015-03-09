--彼岸之骁骑（界马超）
function c9990301.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--铠翼鸦效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(c9990301.con)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	--目标敌阵，全军突击！
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c9990301.target)
	e3:SetOperation(c9990301.operation)
	c:RegisterEffect(e3)
end
function c9990301.con(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c9990301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():IsFaceup() end
	local tc=Duel.GetAttackTarget()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c9990301.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_BATTLED)
		e3:SetOperation(c9990301.val)
		e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9990301.val(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget():IsRelateToBattle() then
		Duel.Destroy(Duel.GetAttackTarget(),REASON_EFFECT)
	end
end
