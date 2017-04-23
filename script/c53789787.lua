--Tao's Spirit Linker
function c53789787.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c53789787.filter)
	--spirit stays onfield
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c53789787.atkval)
	c:RegisterEffect(e2)
	--Untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(c53789787.tglimit)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53789787,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,53789787)
	e4:SetCondition(c53789787.thcon)
	e4:SetTarget(c53789787.thtg)
	e4:SetOperation(c53789787.thop)
	c:RegisterEffect(e4)
end
function c53789787.filter(c)
	return c:IsType(TYPE_SPIRIT)
end
function c53789787.atkval(e,c)
	return c:GetLevel()*200
end
function c53789787.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_MONSTER) 
end
function c53789787.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c53789787.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c53789787.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end