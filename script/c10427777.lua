--劣等生 司波达也
function c10427777.initial_effect(c)
         c:EnableReviveLimit()
		 --special summon condition
local e1=Effect.CreateEffect(c)
	  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	  c:RegisterEffect(e1)
	   --special summon
local e2=Effect.CreateEffect(c)
	  e2:SetType(EFFECT_TYPE_FIELD)
	  e2:SetCode(EFFECT_SPSUMMON_PROC)
	  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	  e2:SetRange(LOCATION_EXTRA)
	  e2:SetCountLimit(1,10427777+EFFECT_COUNT_CODE_DUEL)
	  e2:SetCondition(c10427777.spcon)
	  c:RegisterEffect(e2)
	   --add x
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10427777,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(c10427777.mattg)
	e3:SetOperation(c10427777.matop)
	c:RegisterEffect(e3)
	  --add x2
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetDescription(aux.Stringid(95503687,2))
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10427777.condition4)
	e4:SetCost(c10427777.cost4)
	e4:SetTarget(c10427777.target4)
	e4:SetOperation(c10427777.operation4)
	c:RegisterEffect(e4)
	--negate
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10427777,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c10427777.cost5)
	e5:SetTarget(c10427777.target5)
	e5:SetOperation(c10427777.operation5)
	c:RegisterEffect(e5)
	--forbi
local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10427777,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c10427777.cost6)
	e6:SetTarget(c10427777.target6)
	e6:SetOperation(c10427777.operation6)
	c:RegisterEffect(e6)
end
function c10427777.matfilter(c)
	return c:IsSetCard(0xa42) 
end
function c10427777.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>3
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetLP(c:GetControler())<=2000
end
function c10427777.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10427777.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c10427777.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c10427777.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>=0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end
function c10427777.condition4(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c10427777.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c10427777.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE+LOCATION_REMOVED end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
end
function c10427777.operation4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
	if g:GetCount()>=0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end
function c10427777.thfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c10427777.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10427777.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and c10427777.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10427777.thfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10427777.thfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
end
function c10427777.operation5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_DISABLE)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_DISABLE_EFFECT)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		tc:RegisterEffect(e6)
	end
end
function c10427777.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10427777.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c10427777.operation6(e,tp,eg,ep,ev,re,r,rp)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c10427777.bantg)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(c10427777.bantg)
	e2:SetLabel(e:GetLabel())
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,tp)
end
function c10427777.bantg(e,c)
	return c:IsCode(e:GetLabel())
end

