--红色的世界 蕾米莉亚·斯卡雷特
function c73300022.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c73300022.damcon1)
	e1:SetTarget(c73300022.damtg1)
	e1:SetOperation(c73300022.damop1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c73300022.damcon1)
	e2:SetTarget(c73300022.damtg1)
	e2:SetOperation(c73300022.damop1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c73300022.aclimit)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c73300022.reptg)
	e4:SetValue(c73300022.repval)
	c:RegisterEffect(e4)
end
function c73300022.filter2(c,tp)
	return not c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c73300022.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c73300022.filter2,1,nil,tp)
end
function c73300022.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(eg:GetFirst():GetSummonPlayer())
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,eg:GetFirst():GetSummonPlayer(),800)
end
function c73300022.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c73300022.aclimit(e,c)
	return c:IsFacedown()
end
function c73300022.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x733)
end
function c73300022.repfilter1(c)
	return c:IsFacedown() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c73300022.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c73300022.repfilter,1,nil,tp) end
	if Duel.IsExistingMatchingCard(c73300022.repfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(73300022,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g1=Duel.SelectMatchingCard(tp,c73300022.repfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT+REASON_REPLACE)
		local g=eg:Filter(c73300022.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c73300022.repval(e,c)
	return c==e:GetLabelObject()
end