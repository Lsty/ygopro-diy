--悲惨少女 蕾米莉亚·斯卡雷特
function c73300021.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c73300021.spcon)
	e1:SetOperation(c73300021.spop)
	c:RegisterEffect(e1)
	if not c73300021.global_check then
		c73300021.global_check=true
		c73300021[0]=false
		c73300021[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c73300021.chop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c73300021.clear)
		Duel.RegisterEffect(ge2,0)
	end
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c73300021.descon)
	e2:SetTarget(c73300021.destg)
	e2:SetOperation(c73300021.desop)
	c:RegisterEffect(e2)
end
function c73300021.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(tp,73300021)==0 and c73300021[c:GetControler()] and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c73300021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,73300021,RESET_PHASE+PHASE_END,0,1)
end
function c73300021.chop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x734) and rc:IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c73300021[rp]=true
	end
end
function c73300021.clear(e,tp,eg,ep,ev,re,r,rp)
	c73300021[0]=false
	c73300021[1]=false
end
function c73300021.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEDOWN)~=0
end
function c73300021.filter(c,e,tp)
	return c:IsSetCard(0x733) and c:IsAbleToHand()
end
function c73300021.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c73300021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73300021.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c73300021.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c73300021.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end