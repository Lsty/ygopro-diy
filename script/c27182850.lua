--指挥家·奈特巴格
function c27182850.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),4,2)
	c:EnableReviveLimit()
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetOperation(c27182850.checkop)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	e1:SetLabelObject(g)
	g:KeepAlive()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetOperation(c27182850.checkop2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27182850,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c27182850.spcon)
	e3:SetTarget(c27182850.sptg)
	e3:SetOperation(c27182850.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c27182850.desop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,27182850)
	e5:SetCondition(c27182850.spcon1)
	e5:SetOperation(c27182850.spop1)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--counter
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(27182850,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c27182850.cost)
	e6:SetOperation(c27182850.operation)
	c:RegisterEffect(e6)
end
function c27182850.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t=Duel.GetAttackTarget()
	if t and t~=c and t:GetCounter(0xf)>0 then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c27182850.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabelObject():GetLabel()==0 then return end
	local t=Duel.GetAttackTarget()
	if t==c then t=Duel.GetAttacker() end
	local g=e:GetLabelObject():GetLabelObject()
	if c:GetFieldID()~=e:GetLabel() then
		g:Clear()
		e:SetLabel(c:GetFieldID())
	end
	if c:IsRelateToBattle() and t:IsLocation(LOCATION_GRAVE) and t:IsReason(REASON_BATTLE) then
		g:AddCard(t)
		t:RegisterFlagEffect(27182850,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end
function c27182850.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFieldID()==e:GetLabelObject():GetLabel()
end
function c27182850.filter(c,e,tp)
	return c:GetFlagEffect(27182850)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27182850.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject():GetLabelObject():GetLabelObject()
	if chk==0 then return g:IsExists(c27182850.filter,1,nil,e,tp) end
	local dg=g:Filter(c27182850.filter,nil,e,tp)
	g:Clear()
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,dg,dg:GetCount(),0,0)
end
function c27182850.sfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27182850.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c27182850.sfilter,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if sg:GetCount()>ft then sg=sg:Select(tp,ft,ft,nil) end
	local tc=sg:GetFirst()
	local c=e:GetHandler()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(27182850,RESET_EVENT+0x1fe0000,0,0)
		c:CreateRelation(tc,RESET_EVENT+0x1020000)
		tc=sg:GetNext()
	end
end
function c27182850.desfilter(c,rc)
	return c:GetFlagEffect(27182850)~=0 and rc:IsRelateToCard(c)
end
function c27182850.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c27182850.desfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	Duel.Destroy(dg,REASON_EFFECT)
end

function c27182850.cfilter(c)
	return c:IsSetCard(0x3dd) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c27182850.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(c27182850.cfilter,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c27182850.cfilter,tp,LOCATION_HAND,0,1,99,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
end
function c27182850.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local ct=e:GetLabel()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27182850,2))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0xf,1)
	end
end
function c27182850.spcon1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0xf,4,REASON_COST)
end
function c27182850.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0xf,4,REASON_RULE)
end