--Moonlight Butterfly
--lua script by SGJin
function c12310733.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--Immune to Traps while Moonlight Butterfly has overlay units (flying)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12310733.utcon)
	e1:SetValue(c12310733.utfilter)
	c:RegisterEffect(e1)
	--Cant be attacked while Moonlight Butterfly has overlay units (flying)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12310733.utcon)
	c:RegisterEffect(e2)
	--Set card destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetDescription(aux.Stringid(12310733,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12310733.descost)
	e3:SetTarget(c12310733.destg)
	e3:SetOperation(c12310733.desop)
	c:RegisterEffect(e3)
	--Drops Humanity
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310733,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c12310733.thcon)
	e4:SetTarget(c12310733.thtg)
	e4:SetOperation(c12310733.thop)
	c:RegisterEffect(e4)
end
function c12310733.utcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c12310733.utfilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c12310733.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12310733.desfilter(c)
	return c:IsFacedown() and c:IsDestructable() and c:GetSequence()<5
end
function c12310733.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c12310733.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310733.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12310733.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c12310733.limit(g:GetFirst()))
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c12310733.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c12310733.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c12310733.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310733.thfilter(c)
	return c:IsCode(12310712) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310733.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310733.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12310733.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310733.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
