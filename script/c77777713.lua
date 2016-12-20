--Witchcrafter Blair
function c77777713.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777713.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777713,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777713.sccon)
--	e3:SetTarget(c77777713.sctg)
	e3:SetOperation(c77777713.scop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetDescription(aux.Stringid(77777713,1))
	e4:SetCondition(c77777713.thcon)
	e4:SetTarget(c77777713.thtg)
	e4:SetOperation(c77777713.thop)
	c:RegisterEffect(e4)
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c77777713.atlimit)
	c:RegisterEffect(e5)
	--Attach
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetDescription(aux.Stringid(77777713,2))
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c77777713.xyztg)
	e6:SetOperation(c77777713.xyzop)
	c:RegisterEffect(e6)
	
end

function c77777713.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777713.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777713.scop(e,tp,eg,ep,ev,re,r,rp)
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


function c77777713.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc
end
function c77777713.filter(c)
	return c:IsSetCard(0x407) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777713.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if chk==0 then return c:IsDestructable() and pc:IsDestructable()
		and Duel.IsExistingMatchingCard(c77777713.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777713.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777713.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777713.atlimit(e,c)
	return c~=e:GetHandler()
end


function c77777713.xmfil2(c,xyzmat)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x407) and xyzmat:IsCanBeXyzMaterial(c)
end
function c77777713.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c77777713.xmfil2(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c77777713.xmfil2,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c77777713.xmfil2,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
end
function c77777713.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
