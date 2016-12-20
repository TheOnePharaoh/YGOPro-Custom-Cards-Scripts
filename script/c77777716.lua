--Witchcrafter Lilica
function c77777716.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2,nil,nil,5)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777716.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777716,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777716.sccon)
--	e3:SetTarget(c77777716.sctg)
	e3:SetOperation(c77777716.scop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777716,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c77777716.sptg)
	e4:SetOperation(c77777716.spop)
	c:RegisterEffect(e4)
	--Pendulum Place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777716,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,77777816)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77777716.pcon)
	e5:SetOperation(c77777716.pop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777716,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,77777716)
	e6:SetCost(c77777716.rmcost)
	e6:SetTarget(c77777716.rmtg)
	e6:SetOperation(c77777716.rmop)
	c:RegisterEffect(e6)
	--atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetCondition(c77777716.adcon)
	e7:SetValue(c77777716.adval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	--cannot be target
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c77777716.tgcon)
	e9:SetValue(aux.tgoval)
	c:RegisterEffect(e9)
	--cannot be destroyed
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c77777716.indcon)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--direct attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_DIRECT_ATTACK)
	e11:SetCondition(c77777716.dircon)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e12:SetCondition(c77777716.atkcon)
	e12:SetOperation(c77777716.atkop)
	c:RegisterEffect(e12)
end

c77777716.pendulum_level=4
function c77777716.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777716.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777716.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end


function c77777716.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77777716.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.Overlay(c,Group.FromCards(tc))
			end
		end
	end
end

function c77777716.pcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))
end
function c77777716.pop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end


function c77777716.filter(c)
	return c:IsSetCard(0x407) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777716.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c77777716.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c77777716.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c77777716.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777716.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c77777716.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77777716.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c77777716.filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c77777716.adcon(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c77777716.adval(e,c)
	return e:GetHandler():GetOverlayCount()*200
end
function c77777716.tgcon(e)
	return e:GetHandler():GetOverlayCount()>=4
end
function c77777716.indcon(e)
	return e:GetHandler():GetOverlayCount()>=4
end
function c77777716.dircon(e)
	return e:GetHandler():GetOverlayCount()>=5
end
function c77777716.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=5 and ep~=tp and Duel.GetAttackTarget()==nil
end
function c77777716.atkop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end