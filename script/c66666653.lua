--Dogoran Spawn, the Slightly Peeved Flame Kaiju
function c66666653.initial_effect(c)
	c:SetUniqueOnField(1,0,20000000)
	--Change Control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
--	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c66666653.ctlcon)
	e1:SetTarget(c66666653.ctltg)
	e1:SetOperation(c66666653.ctlop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c66666653.grvcon)
	c:RegisterEffect(e2)
end

function c66666653.ctlcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c66666653.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--	if chkc then return false end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged()end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c66666653.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and not Duel.GetControl(tc,1-tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end


function c66666653.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3) and not c:IsCode(66666653)
end

function c66666653.grvcon(e)
	return Duel.IsExistingMatchingCard(c66666653.filter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end