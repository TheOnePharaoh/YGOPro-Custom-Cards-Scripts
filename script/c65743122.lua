--Earthbound Immortal Meska
function c65743122.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c65743122.sdcon)
	c:RegisterEffect(e1)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--direct atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65743122,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c65743122.ntcon)
	e4:SetOperation(c65743122.ntop)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c65743122.efcon)
	e5:SetOperation(c65743122.efop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(65743122,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetTarget(c65743122.target)
	e6:SetOperation(c65743122.operation)
	c:RegisterEffect(e6)
end
function c65743122.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end
function c65743122.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c65743122.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65743122,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c65743122.tgcon)
	e1:SetTarget(c65743122.tgtg)
	e1:SetOperation(c65743122.tgop)
	e1:SetReset(RESET_EVENT+0xc6e0000)
	c:RegisterEffect(e1)
end
function c65743122.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c65743122.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(65743122,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65743122.atkcon)
	e1:SetOperation(c65743122.atkop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c65743122.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c65743122.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c65743122.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x21) and c:IsAbleToHand()
end
function c65743122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65743122.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65743122.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65743122.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65743122.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c65743122.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c65743122.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c65743122.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		Duel.Damage(tp,1200,REASON_EFFECT)
	end
end
